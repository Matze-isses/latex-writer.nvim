


local function draw_pending(pending_item, config)
    if pending_item.row < 0 then return end

    local text_before = config.virt_text_params.string_before
    local name_space = vim.api.nvim_create_namespace('tex_namespace')

    local virt_text_lines = {}
    for _, line in ipairs(pending_item.texts) do
        table.insert(virt_text_lines, {{line, 'LatexWriter'}})
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
        end
    end

    local pending_item = {row = -1, texts = {}}

    for _, ltex in ipairs(ltex_rep) do
        text = ltex.text
        local lines = {}
        for line in string.gmatch(text, "([^\n]+)\n") do lines[#lines+1] = line end
        while #lines < 3 do lines[#lines+1] = "" end

        -- if the last and the current item are in the same row draw them after each other
        if pending_item.row == ltex.row then
            local max_line_length = 0
            for _, line in pairs(pending_item.texts) do max_line_length = math.max(max_line_length, #line) end

            for i, line in ipairs(pending_item.texts) do
                local between = string.rep(".", ltex.col - max_line_length + 4)
                pending_item.texts[i] = line .. between .. (lines[i] or "") .. string.rep("-", ltex.col_end - #line - ltex.col)
            end

        -- draw pending item (exclusion for the first item is done in the draw_pending function)
        else
            draw_pending(pending_item, config)
            for i=1,#lines do
                lines[i] = text_before .. string.rep(" ", ltex.col - #text_before) .. lines[i]
                if i == 1 then
                    lines[i] = lines[i] .. string.rep(" ", ltex.col_end - #lines[i] + (i - 1))
                else
                    lines[i] = lines[i] .. string.rep(" ", ltex.col_end - #lines[i] + (i - 1) + 2)
                end
            end

            pending_item = {row = ltex.row, texts = lines, col = ltex.col_end}
        end
    end
    draw_pending(pending_item, config)
end
