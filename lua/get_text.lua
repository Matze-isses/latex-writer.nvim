

---Searches per line for latex elements
---@param inputString string
---@return table
local function search_inline(inputString)
    local patterns = {
        {open = "\\%(", close = "\\%)"},
        {open = "\\%[", close = "\\%]"},
        {open = "\\%$", close = "\\%$"},
        {open = "\\%$%$", close = "\\%$%$"}
    }
    local matches = {}
    for match in string.gmatch(inputString, '\\%(%s*(.*)%s*\\%)') do
        local start_index, end_index = string.find(inputString, '\\%(%s*(.*)%s*\\%)')
        local result = string.sub(inputString, start_index + 2, end_index - 2)
        table.insert(matches, result)
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
                    match = string.gsub(match, "\\", "\\\\")
                    table.insert(items, {text = match, row = i-1, col = 1})
                end
            end
        end
        return items
end

