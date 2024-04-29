local get_latex_codes = require('latex-writer.get_text')
local display_virtual_text = require('latex-writer.virt_text')
local exec_shell = require('dev_latex.connect_shell')

LatexWriter = { }
LatexWriter.__index = LatexWriter

local function get_plugin_path()
    return vim.g.latex_writer_plugin_path
end

--- \(\sum_{i=1}^{n} i\)

LatexWriter = {
    plugin_path = get_plugin_path(),
    parser_path = nil,

    config = {
        autocmds = false,
        usercmds = true,
        file_types = {'tex'},
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
        vim.api.nvim_create_user_command('LatexWriterStart', function () LatexWriter.update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterRemove', function () LatexWriter.remove() end, {nargs = 0})
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

function LatexWriter.setup(opts)
    local self = setmetatable(LatexWriter, {config = opts})

    if self.config.autocmds == true then self._set_auto_cmds() end
    if self.config.usercmds == true then self._set_user_cmds() end

    self.plugin_path = vim.fn.expand('%:h:h:h')
    self.parser_path = vim.fn.expand('%:h:h:h') .. '/src/input_parser.sh'
    exec_shell("(hello \\int)")
    return self
end

LatexWriter.setup({})
return LatexWriter
