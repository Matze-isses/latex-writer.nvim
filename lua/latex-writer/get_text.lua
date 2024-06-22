local tex_regex = {
    {regex = '\\%(%s*(.*)%s*\\%)', length_start = 2},
    {regex = '\\%( (.*) \\%)',     length_start = 2},
    {regex = '\\%[%s*(.*)%s*\\%]', length_start = 2},
}
local tex_regex_multiline = {
    {regex = '\\%[%s*(.*)%s*\\%]', length_start = 2},
}

---\[
--- \int
---\]

local function text_cleanup(text)
    text = string.gsub(text, "(%a*%s+)(%a+)", "%1{%2}")
    text = string.gsub(text, "\\", "\\\\")
    text = string.gsub(text, " ", "")
    return text
end



---Searches per line for latex elements
---@param inputString string
---@return table
local function search_inline(inputString)
    local matches = {}
    local start_index, end_index


    -- Iterate through all the patterns
    for _, pattern in ipairs(tex_regex) do
        start_index, end_index = 1, 1

        -- If there is a match then obtain the indexes, and if there are multiple, iterate through them.
        for _ in string.gmatch(inputString, pattern.regex) do
            start_index, end_index = string.find(inputString, pattern.regex, end_index or 1)
            local result = string.sub(inputString, start_index + pattern.length_start, end_index - pattern.length_start)

            matches[#matches + 1] = {tex = result, start_index = start_index, end_index = end_index}
        end
    end
    return matches
end



local function search_in_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local items = {}
    local multiline_lines = {}

    for index, line in ipairs(lines) do
        local matches = search_inline(line)
        if #matches == 0 then multiline_lines[#multiline_lines + 1] = {line_nr = index, line = line} end

        for _, match in ipairs(matches ) do
            local row = index - 1
            items[#items+1] = {text = text_cleanup(match.tex), row = row, col = matches.col}
        end
    end

    local text = ""
    for _, mult_lines in ipairs(multiline_lines) do
        local line_nr, line = mult_lines.line_nr, mult_lines.line
        text = text .. line

        for _, pattern in ipairs(tex_regex_multiline) do
            local start_index, end_index = string.find(text, pattern.regex)

            if start_index then
                local result = string.sub(text, start_index + pattern.length_start, end_index - pattern.length_start)
                items[#items + 1] = {text = text_cleanup(result), row = line_nr-1, col = 0}
                text = ""
            end
        end
    end
    text = text:gsub(" ", " ")

    return items
end

local found_items = ""
for _, item in ipairs(search_in_buffer()) do
    found_items = found_items .. item.row .. "   " .. item.text
end
-- print(found_items)

return search_in_buffer
