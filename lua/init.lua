local utf8 = require('utf8')

--- \( \sum_{i=1}^{n} i \)
---
---
--- \( \sum_{i=1}^{n}i \)
---
---
---
--- $\int_{r\in{R}}^{\infty}{x}\text{d}{x}$

M = { }
M.__index = M

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*[/\\])") or "./"
end

local path = script_path()
path = path .. "tex2utf.pl"

local function split_str(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

---comment
---@param inputString string
---@return table
local function search_inline(inputString)
    local patterns = {
        {str = '\\%(%s*(.*)%s*\\%)', length_start = 2},
        {str = '\\%[%s*(.*)%s*\\%]', length_start = 2},
        {str = '$%s*(.*)%s*$', length_start = 1},
        {str = '\\%(%s*(.*)%s*\\%)', length_start = 2},
        {str = '\\%( (.*) \\%)', length_start = 2},
    }
    local matches = {}
    for _, pattern in ipairs(patterns) do
        for match in string.gmatch(inputString, pattern.str) do
            print(match)
            local start_index, end_index = string.find(inputString, pattern.str)
            local result = string.sub(inputString, start_index + 2, end_index - 2)
            matches[#matches + 1] = string.gsub(result, "\\", "\\\\")
        end
    end
    return matches
end

M = {

    defaults = {
        start_col = 130,
    },

    print_text = function(text_object)
        local name_space = vim.api.nvim_create_namespace('tex_namespace')

        if type(text_object.text) == "string" then
            --text_object.text = {text_object.text}
            text_object.text = split_str(text_object.text, '\n')
        end
        local printed_string = ''
        for i, text in ipairs(text_object.text) do
            local virtual_text_opts = {
                virt_text_pos = 'inline',
                virt_text_win_col = 100,
                virt_text = {{text, 'Warning'}},
            }
            printed_string = printed_string .. text .. "  |  "
            vim.api.nvim_buf_set_extmark(0, name_space, text_object.row + i - 2, 0, virtual_text_opts)
        end
        --print("PRINTED STRING", printed_string)
    end,

    get_items = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local items = {}
        for i, line in ipairs(lines) do
            local matches = search_inline(line)
            if #matches > 0 then
                for _, match in ipairs(matches) do
                    match = match
                    table.insert(items, {text = match, row = i-1, col = 1})
                end
            end
        end
        return items
    end,

    update = function ()
        local items = M.get_items()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
        for _, item in ipairs(items) do
            local updated = item
            updated.text = vim.api.nvim_call_function('GetLatex', {item.text})
            M.print_text(updated)
        end
    end
}
--- \( \sum_{i=1}^{n} test\)
--- \( \sum_{i=1}^{n} ip \)
--print("NUMBER OBTAINED ITEMS", #M.get_items())
local overall = ''
for _, item in ipairs(M.get_items()) do
    overall = overall .. item.text .. '\n ---------------- \n'
end

local result = vim.api.nvim_call_function('GetLatex', {[[\int_{-\infty}^{\infty} e^{-x^2} dx]]})
--print(result == nil or result == '')
--print("RESULT", result:sub(1, #result - 15))
M.update()

function M.setup() end
function M.init(opts) end
