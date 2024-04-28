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

LatexWriter = {

    setup = function (opts)
        opts = opts or {}
        for name, value in pairs(opts) do
            if LatexWriter.settings[name] then LatexWriter.settings[name] = value end
        end

        if LatexWriter.settings.autocmds == true then LatexWriter._set_auto_cmds() end
        if LatexWriter.settings.user == true then LatexWriter._set_user_cmds() end

        return opts
    end,

    settings = {
        autocmds = true,
        usercmds = true,
        plugin_path = vim.g.runtimepath,
        highlighting = {
            text = 'Todo',
            background = ''
        }
    },

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

    init = function (opts)
    end
}
--- \( \sum_{i=1}^{n} test\)
--- \(\sum_{i=1}^{n}{ip}\)
LatexWriter.setup({autocmds = true})
return LatexWriter
