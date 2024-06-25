


local function draw_pending(pending_item, config)
    if pending_item.row < 0 then return end

    local text_before = config.virt_text_params.string_before
    local name_space = vim.api.nvim_create_namespace('tex_namespace')

    local virt_text_lines = {}
    for _, line in ipairs(pending_item.texts) do
        table.insert(virt_text_lines, {{text_before .. line, 'LatexWriter'}})
    end

    local virtual_text_opts = {
        virt_lines = virt_text_lines,
        virt_lines_above = false,  -- Set to true to display above the line_number
        virt_lines_leftcol = false, -- Set to true to align with the leftmost column
        sign_text = "",
    }

    vim.api.nvim_buf_set_extmark(0, name_space, pending_item.row, 0, virtual_text_opts)
end


return function (items, config)
    local used_texts = {}  -- to avoid duplicates
    local ltex_rep = {}  -- to avoid duplicates
    local text = ''
    local text_before = config.virt_text_params.string_before


    for _, item in ipairs(items) do
        if not vim.tbl_contains(used_texts, item.text) then
            used_texts[#used_texts + 1] = item.text
            ltex_rep[#used_texts] = item
            for name, value in pairs(ltex_rep[#used_texts]) do print(name, value) end
        end
    end

    local pending_item = {row = -1, texts = {}}

    for _, ltex in ipairs(ltex_rep) do
        text = ltex.text
        local lines = {}
        for line in string.gmatch(text, "([^\n]+)\n") do lines[#lines+1] = line end

        -- if the last and the current item are in the same row draw them after each other
        if pending_item.row == ltex.row then

            if #pending_item.texts == 3 and #lines == 1 then -- hard coded because most common case
                local between = string.rep(" ", ltex.col_end - #pending_item.texts[2])
                pending_item.texts[2] = pending_item.texts[2] .. between .. lines[1]
            else
                for i, line in ipairs(lines) do
                    local between = string.rep(" ", ltex.col - #pending_item.texts[i])
                    pending_item.texts[i] = (pending_item.texts[i] or "") .. between .. line
                end
            end
            for i=1,#pending_item.texts do
                pending_item.texts[i] = pending_item.texts[i] .. string.rep(" ", ltex.col_end - #pending_item.texts[i])
            end
        -- draw pending item (exclusion for the first item is done in the draw_pending function)
        else
            draw_pending(pending_item, config)
            for i=1,#lines do lines[i] = text_before .. string.rep(" ", ltex.col - #text_before) .. lines[i] end
            pending_item = {row = ltex.row, texts = lines, col = ltex.col_end}
        end
    end
    draw_pending(pending_item, config)
end
