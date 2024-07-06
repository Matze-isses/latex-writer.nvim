-- i hate regex especially in lua
local tex_regex_multiline = {
    {regex = '\\%[%s*(.-)%s*\\%]', length_start = 2},
    {regex = '\\%(%s*(.-)%s*\\%)', length_start = 2},
    {regex = '%$%s*(.-)%s*%$', length_start = 1},
    {regex = '%$%$%s*(.-)%s*%$%$', length_start = 2},
}

local test = [[

This is a test string.

\[ \sum \]

\[
    \int_0^n
\]

And other option is \( \Omega \)
With\(\lambda\) old tex Format $\Lambda$ testing this \(\to\) \[ \Pi \] \( \pi \)
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

local function search_in_buffer()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local items = {}
    local text = ""


    for _, pattern in ipairs(tex_regex_multiline) do
        text = ""

        for line_nr, line in ipairs(lines) do
            text = text .. line
            local start_index, end_index = string.find(text, pattern.regex)

            local prevent_inf_loop = 0
            local text_length_before = #text

            while start_index and prevent_inf_loop < 100 do
                prevent_inf_loop = prevent_inf_loop + 1

                local result = string.sub(text, start_index + pattern.length_start, end_index - pattern.length_start)

                local start_column = #line - text_length_before + start_index

                if items[#items] and items[#items].row == line_nr then start_column = start_column + items[#items].col_end end
                if start_column < 0 then start_column = 4 end

                items[#items + 1] = {text = text_cleanup(result), row = line_nr - 1, col = start_column, col_end = text_length_before - end_index}
                text = string.sub(text, end_index + 1, #text)

                start_index, end_index = string.find(text, pattern.regex)
            end
        end
    end

    return items
end

local items = search_in_buffer()

for key, value in pairs(items) do
    print("Key: " .. key, "Row: " .. value.row, "ColStart: " .. value.col, "ColEnd: " .. value.col_end, "Text: " .. value.text)
end

