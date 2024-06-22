local letter_parser = require('latex-writer.parse_text.parse_letters').parse_letters


local function shell_connection(path, command)
    command = 'perl ' .. path .. ' < <(echo \"' .. command ..'\")'

    local output = vim.fn.system(command)

    if output == nil or output == '' then
        print("No output from script or error occurred.")
        print("Script path: " .. path)
        print("Script CMD:")
        error("Missing output of Script")
    end

    return output
end

local function get_visual_selection()
    -- Get the start and end positions of the visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")

    -- Extract line and column numbers
    local start_line = start_pos[2]
    local start_col = start_pos[3]
    local end_line = end_pos[2]
    local end_col = end_pos[3]

    -- Get the lines from the buffer within the range
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    -- If only one line is selected, adjust the column range
    if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col, end_col)
    else
        -- For the first line, adjust the starting column
        lines[1] = string.sub(lines[1], start_col)

        -- For the last line, adjust the ending column
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end

    -- Concatenate the lines into a single string
    local selected_text = table.concat(lines, "\n")

    return selected_text
end


local function add_lines_below_cursor(lines_to_add)
    -- Ensure lines_to_add is a table
    if type(lines_to_add) ~= "table" then
        print("lines_to_add should be a table of strings")
        return
    end

    -- Get the current buffer
    local buf = vim.api.nvim_get_current_buf()

    -- Get the current cursor position (row and column)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local current_row = cursor_pos[1]

    -- Calculate the row to insert lines below
    local insert_row = current_row

    -- Insert lines below the current row
    vim.schedule(function ()
        vim.api.nvim_buf_set_lines(buf, insert_row, insert_row, false, lines_to_add)
    end)
end


local function convert_visual()
    if vim.api.nvim_get_mode().mode ~= "v" then
        return
    end
    local text = get_visual_selection()
    text = text:gsub("\\", "\\\\")
    local proc = letter_parser(text)
    proc = shell_connection(LatexWriter.parser_path, proc)

    local lines = {}
    for line in string.gmatch(proc, "([^\n]*)\n") do
        lines[#lines+1] = line:gsub("\n", "")
        print(line)
    end

    add_lines_below_cursor(lines)
end

--- \( \sum \)

vim.api.nvim_buf_set_keymap(0, 'v', 't', "", {callback = function () convert_visual() end, expr=true})

return {
    get_latex_text = function (text)
        local proc = letter_parser(text)
        proc = shell_connection(letter_parser)
        proc = proc:gsub("\\", "")
        return proc
    end,

    convert_visual_selection = convert_visual,
}
