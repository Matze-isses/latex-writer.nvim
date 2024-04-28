local tex_regex = {
    {regex = '\\%(%s*(.*)%s*\\%)', length_start = 2},
    {regex = '\\%[%s*(.*)%s*\\%]', length_start = 2},
    {regex = '$%s*(.*)%s*$',       length_start = 1},
    {regex = '\\%(%s*(.*)%s*\\%)', length_start = 2},
    {regex = '\\%( (.*) \\%)',     length_start = 2},
}


local function text_cleanup(text)
    text = string.gsub(text, "(%a*%s+)(%a+)", "%1{%2}")
    text = string.gsub(text, "\\", "\\\\")
    text = string.gsub(text, " ", "")
    return text
end

-- print(text_cleanup("hello \\textbf{world}"), text_cleanup("\\int_{i = 1} h \\text{dx}"), text_cleanup("\\int_{i = 1}^{n} \\mathbb R"))


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
            -- start at last end index or 1 with the search and Escape backslashes to prevent errors
            start_index, end_index = string.find(inputString, pattern.regex, end_index or 1)
            local result = string.sub(inputString, start_index + pattern.length_start, end_index - pattern.length_start)
            matches[#matches + 1] = {tex = text_cleanup(result), index = start_index}
        end
    end
    return matches
end



return function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local items = {}

    for i, line in ipairs(lines) do
        local matches = search_inline(line)

        if #matches > 0 then
            for _, match in ipairs(matches) do
                items[#items+1] = {text = match.tex, row = i-1, col = match.index}
            end
        end
    end
    return items
end

