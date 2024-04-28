local get_latex_codes = require('latex-writer.get_text')
local display_virtual_text = require('latex-writer.virt_text')

LatexWriter = { }
LatexWriter.__index = LatexWriter

local function get_plugin_path()
    return vim.g.latex_writer_plugin_path
end

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
        autocmds = false,
        usercmds = true,
        file_types = {'tex'},
        plugin_path = get_plugin_path(),
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
LatexWriter.__index = LatexWriter

return LatexWriter
