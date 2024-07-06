-- i hate regex especially in lua
local tex_regex = {
    {regex = "\\%((.-)\\%)", length_start = 2},
    {regex = "\\%[(.-)\\%]", length_start = 2},
}
local tex_regex_multiline = {
    {regex = '\\%[%s*(.*)%s*\\%]', length_start = 2},
    {regex = '\\%(%s*(.*)%s*\\%)', length_start = 2},
    {regex = '%$%s*(.*)%s*%$', length_start = 1},
}

local test = [[

This is a test string.

\[ \sum \]

\[
    \int_0^n
\]

And other option is \( \Omega \)
With old tex Format $\Lambda$
test
\[
    \omega \Pi
\]

]]

local function text_cleanup(text)
    text = string.gsub(text, "\\\\", "\\\\\\\\")
    if text[1] == " " then text = text:sub(2, #text) end
    return text
end


---Searches per line for latex elements
---@param inputString string
---@return table
local function search_inline(inputString)
    local matches = {}
    local num_matches = #matches - 1
    local current_search = {}
    for i=1,#tex_regex do current_search[#current_search + 1] = inputString end

    while num_matches ~= #matches do
        num_matches = #matches

        -- Iterate through all the patterns
        for i, pattern in ipairs(tex_regex) do
            local start_index, end_index = string.find(current_search[i], pattern.regex, 1)
            if not start_index or not end_index then break end

            local result = string.sub(current_search[i], start_index + pattern.length_start, end_index - pattern.length_start)
            matches[#matches + 1] = {tex = result, start_index = start_index, end_index = end_index}
            current_search[i] = string.sub(current_search[i], end_index - 2, #current_search[i])
        end
    end
    return matches
end



local function search_in_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local items = {}
    local text = ""
    local overline = false

    for line_nr, line in ipairs(lines) do
        text = text .. line

        for _, pattern in ipairs(tex_regex_multiline) do
            local start_index, end_index = string.find(text, pattern.regex)


            if start_index then
                local result = string.sub(text, start_index + pattern.length_start, end_index - pattern.length_start)

                local start_column = #text - start_index
                print(start_index, end_index)
                if #lines[line_nr] < start_index then
                    start_column = 4
                end

                items[#items + 1] = {text = text_cleanup(result), row = line_nr - 1, col = start_column, col_end = end_index}
                text = ""
            end
        end
    end

    return items
end

local items = search_in_buffer()

for key, value in pairs(items) do
    print("Key: " .. key, "Text: " .. value.text, "Row: " .. value.row, "ColStart: " .. value.col, "ColEnd: " .. value.col_end)
end

