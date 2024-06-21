local tex_regex = {
    {regex = '\\%(%s*(.*)%s*\\%)', length_start = 2},
    {regex = '\\%[%s*(.*)%s*\\%]', length_start = 2},
    {regex = '$%s*(.*)%s*$',       length_start = 1},
    {regex = '\\%(%s*(.*)%s*\\%)', length_start = 2},
    {regex = '\\%( (.*) \\%)',     length_start = 2},
    {regex = '\\%[ ([%s%S]+?)(?:\\]) \\%]',     length_start = 2},
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
            -- start at last end index or 1 with the search and Escape backslashes to prevent errors
            start_index, end_index = string.find(inputString, pattern.regex, end_index or 1)
            local result = string.sub(inputString, start_index + pattern.length_start, end_index - pattern.length_start)
            matches[#matches + 1] = {tex = text_cleanup(result), index = start_index}
        end
    end
    return matches
end



local function search_in_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local items = {}
    local text = ""

    for _, line in ipairs(lines) do
        text = text .. line
    end

    local matches = search_inline(text)
    local chars = 0

    local running = 1
    for index, line in ipairs(lines) do
        chars = chars + #line
        while matches[running] and matches[running].col and matches[running].col < chars do
            local match = matches[running]
            items[#items+1] = {text = match.tex, row = index-1, col = match.index}
            running = running + 1
        end

    end

    return items
end


return search_in_buffer
