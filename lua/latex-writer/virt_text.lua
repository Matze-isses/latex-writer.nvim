


return function (items, config)
    local name_space = vim.api.nvim_create_namespace('tex_namespace')
    local virt_text_lines = {}
    local used_texts = {}  -- to avoid duplicates
    local ltex_rep = {}  -- to avoid duplicates
    local text = ''

    local text_before = config.virt_text_params.string_before

    for _, item in ipairs(items) do
        if not vim.tbl_contains(used_texts, item.text) then
            used_texts[#used_texts + 1] = item.text
            ltex_rep[#used_texts] = item
        end
    end


    for _, ltex in ipairs(ltex_rep) do
        text = ltex.text
        virt_text_lines = {}

        for line in string.gmatch(text, "([^\n]+)\n") do

            table.insert(virt_text_lines, {{text_before .. line, 'LatexWriter'}})
        end

        local virtual_text_opts = {
            virt_lines = virt_text_lines,
            virt_lines_above = false,  -- Set to true to display above the line_number
            virt_lines_leftcol = true, -- Set to true to align with the leftmost column
            sign_text = "",
        }

        vim.api.nvim_buf_set_extmark(0, name_space, ltex.row, 0, virtual_text_opts)
    end
end
