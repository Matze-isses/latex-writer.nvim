local get_latex_codes = require('latex-writer.get_text')
local display_virtual_text = require('latex-writer.virt_text')
local config_creator = require('latex-writer.config')

LatexWriter = { }
LatexWriter.__index = LatexWriter

local function get_plugin_path()
    return vim.g.latex_writer_plugin_path
end

LatexWriter = {
    plugin_path = get_plugin_path(),
    settings = {},

    update = function ()
        local items = get_latex_codes()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
        display_virtual_text(items)
    end,

    remove = function ()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
    end,

    _set_user_cmds = function ()
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

function LatexWriter.setup(config)
    local cfg = config_creator:set(config):get()
    LatexWriter.settings = cfg

    if cfg.autocmds == true then LatexWriter._set_auto_cmds() end
    if cfg.usercmds == true then LatexWriter._set_user_cmds() end

    return LatexWriter
end

LatexWriter.setup()
return LatexWriter
