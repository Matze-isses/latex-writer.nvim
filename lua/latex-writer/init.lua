local get_latex_codes = require('latex-writer.get_text')
local display_virtual_text = require('latex-writer.virt_text')
local exec_shell = require('latex-writer.connect_shell')

LatexWriter = { }
LatexWriter.__index = LatexWriter

local function get_plugin_path()
    local appended_string = '/src/tex2utf.pl'
    local plugin_path = vim.fn.expand('%:p:h')
    local parser_path = plugin_path .. appended_string
    local running_var = 0

    while plugin_path ~= '/' do
	if running_var > 10 then break else running_var = running_var + 1 end
        parser_path = plugin_path .. appended_string

        -- checks if there is a matching file and if so breaks
        if vim.fn.filereadable(parser_path) == 1 then break end

        -- if no matching file then shorten plugin_path by one directory
        plugin_path = vim.fn.fnamemodify(plugin_path, ':h')
    end

    return plugin_path, parser_path
end

--- \(\sum_{i=1}^{n} i\)

LatexWriter = {
    plugin_path = get_plugin_path(),
    parser_path = nil,

    config = {
        autocmds = false,
        usercmds = true,
        apply_on_filetypes = {'tex', 'markdown'},

        highlighting = {
            fg = 'NONE',
            bg = '#082a2b',
            gui = 'NONE'
        },

        virt_text_params = {
            string_before = string.rep(' ', 8)
        },
    },

    verified_update = function ()
        if vim.tbl_contains(LatexWriter.config.apply_on_filetypes, vim.bo.filetype) then
            LatexWriter.update()
            print("Written")
        end
    end,

    update = function ()
        local items = get_latex_codes()
        for i, item in ipairs(items) do
            items[i].text = exec_shell(LatexWriter.parser_path, item.text)
        end
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
        display_virtual_text(items, LatexWriter.config.virt_text_params)
    end,

    remove = function ()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
    end,

    _set_user_cmds = function ()
        vim.api.nvim_create_user_command('LatexWriterStart', function () LatexWriter.verified_update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterRemove', function () LatexWriter.remove() end, {nargs = 0})
    end,

    _set_auto_cmds = function ()
        local grp = vim.api.nvim_create_augroup("LatexWriter", { clear = true })
        vim.api.nvim_create_autocmd({"CursorHold"}, {
            callback = function ()
                LatexWriter.verified_update()
            end,
        })
    end,

    init = function (opts)
    end
}

function LatexWriter.setup(opts)
    local self = setmetatable(LatexWriter, {config = opts})

    if self.config.autocmds == true then self._set_auto_cmds() end
    if self.config.usercmds == true then self._set_user_cmds() end

    -- There must be a better solution then this one
    self.plugin_path, self.parser_path = get_plugin_path()

    local hl = self.config.highlighting
    vim.cmd('highlight LatexWriter' .. ' guifg=' .. hl.fg .. ' guibg=' .. hl.bg .. ' gui=' .. hl.gui)

    return self
end

--local test = LatexWriter.setup({})
--print(test.parser_path)
-- test.update()

return LatexWriter
