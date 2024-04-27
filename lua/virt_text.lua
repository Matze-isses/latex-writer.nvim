


return function (items)
    local name_space = vim.api.nvim_create_namespace('tex_namespace')

    for _, text_object in ipairs(items) do
        local virt_text_lines = {}

        for line in string.gmatch(text_object.text, "([^\n]+)\n") do
            table.insert(virt_text_lines, {{string.rep(' ', 8) .. line, 'Comment'}})
        end
        print("TEXT OBJECT", #virt_text_lines, text_object.row, text_object.col)

        local virtual_text_opts = {
            virt_lines = virt_text_lines,
            virt_lines_above = false,  -- Set to true to display above the line_number
            virt_lines_leftcol = true -- Set to true to align with the leftmost column
        }
        vim.api.nvim_buf_set_extmark(0, name_space, text_object.row, 0, virtual_text_opts)
    end

end
