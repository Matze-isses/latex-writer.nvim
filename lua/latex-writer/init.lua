local get_latex_codes = require('latex-writer.get_text')
local display_virtual_text = require('latex-writer.virt_text')

LatexWriter = { }
LatexWriter.__index = LatexWriter

local function get_plugin_path()
    return vim.g.latex_writer_plugin_path
end

LatexWriter = {
    plugin_path = get_plugin_path(),
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
    local cfg = require('latex-writer.config'):set(config):get()

    if cfg.autocmds == true then LatexWriter._set_auto_cmds() end
    if cfg.usercmds == true then LatexWriter._set_user_cmds() end

    return cfg
end

--LatexWriter.setup()
return LatexWriter
