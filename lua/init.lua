local utf8 = require('utf8')
local get_latex_codes = require('inline_latex.lua.get_text')

--- \(\sum_{i=1}^{n} i\)
--- \[\sum_{i=1}^{n}\bar i_h^t\]
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

M = {

    defaults = {
        start_col = 130,
    },

    print_text = function(items)
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
    end,

    update = function ()
        local items = get_latex_codes()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)

        for i, item in ipairs(items) do
            local updated = item
            updated.text = vim.api.nvim_call_function('GetLatex', {item.text})
            items[i] = updated
        end
        M.print_text(items)
    end
}
--- \( \sum_{i=1}^{n} test\)
--- \( \sum_{i=1}^{n}{ip} \)
--print("NUMBER OBTAINED ITEMS", #M.get_items())

--local result = vim.api.nvim_call_function('GetLatex', {[[\int_{-\infty}^{\infty} e^{-x^2} dx]]})
--print(result == nil or result == '')
--print("RESULT", result:sub(1, #result - 15))
M.update()

function M.setup() end
function M.init(opts) end
