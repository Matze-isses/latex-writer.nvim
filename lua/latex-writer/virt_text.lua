


return function (items)
    local name_space = vim.api.nvim_create_namespace('tex_namespace')
    local virt_text_lines = {}
    local used_texts = {}  -- to avoid duplicates
    local ltex_rep = {}  -- to avoid duplicates


    for _, item in ipairs(items) do
        if not vim.tbl_contains(used_texts, item.text) then
            used_texts[#used_texts + 1] = item.text
            ltex_rep[#used_texts] = item
            print(item)
            ltex_rep[#used_texts].text = vim.api.nvim_call_function('GetLatex', {item.text})
        end
    end


    for _, ltex in ipairs(ltex_rep) do
        virt_text_lines = {}
        local text = ltex.text

        for line in string.gmatch(text, "([^\n]+)\n") do
            table.insert(virt_text_lines, {{string.rep(' ', 8) .. line, 'Comment'}})
        end

        local virtual_text_opts = {
            virt_lines = virt_text_lines,
            virt_lines_above = false,  -- Set to true to display above the line_number
            virt_lines_leftcol = true -- Set to true to align with the leftmost column
        }

        vim.api.nvim_buf_set_extmark(0, name_space, ltex.row, 0, virtual_text_opts)
    end
end
