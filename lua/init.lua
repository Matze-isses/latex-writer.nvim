local utf8 = require('utf8')
local get_latex_codes = require('inline_latex.lua.get_text')
local display_virtual_text = require('inline_latex.lua.virt_text')

--- \(\sum_{i=1}^{n} i\)
--- \[\sum_{i=1}^{n}\bar i_h^t\]
---
---
---
--- $\int_{r\in{R}}^{\infty}{x}\text{d}{x}$

LatexWriter = { }
LatexWriter.__index = LatexWriter

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*[/\\])") or "./"
end

LatexWriter = {

    update = function ()
        local items = get_latex_codes()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
        display_virtual_text(items)
    end,

    remove = function ()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
    end,

    _set_user_cmds = function ()
        vim.api.nvim_create_user_command('LatexWriterUpdate', function () LatexWriter.update() end, { nargs = 0 })
        vim.api.nvim_create_user_command('LatexWriterUnload', function () LatexWriter.remove() end, { nargs = 0 })
        vim.api.nvim_create_user_command('LatexWriterAuto', function () LatexWriter._set_auto_cmds() end, { nargs = 0 })
    end,

    _set_auto_cmds = function ()
        local grp = vim.api.nvim_create_augroup("LatexWriter", { clear = true })
        vim.api.nvim_create_autocmd({"CursorHold"}, {
            callback = function () LatexWriter.update() end,
        })
    end,

    setup = function (opts)
        opts = opts or {}
        if not opts.disable_commands then
            LatexWriter._set_user_cmds()
        end
        return opts
    end,
}
--- \( \sum_{i=1}^{n} test\)
--- \(\sum_{i=1}^{n}{ip}\)
LatexWriter.update()
LatexWriter.setup()
return LatexWriter
