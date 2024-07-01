local search_in_buffer = require('latex-writer.get_text')
local display_virtual_text = require('latex-writer.virt_text')
local parser = require('latex-writer.parse_text')
LatexWriter = { }
LatexWriter.__index = LatexWriter

local function get_plugin_path()
    local appended_string = '/src/tex2utf/tex2utf.pl'
    local latex_writer_path = vim.fn.fnamemodify( vim.api.nvim_get_runtime_file("lua/latex-writer/init.lua", false)[1], ":p:h:h:h")

    return latex_writer_path, latex_writer_path .. appended_string
end

--- \(\sum_{i=1}^{n} i\)

LatexWriter = {
    plugin_path = get_plugin_path(),
    parser_path = nil,
    augroup = false,

    config = {
        debug = false,

        autocmds = false,
        usercmds = true,
        apply_on_filetypes = {'tex', 'markdown', 'lua'},

        highlighting = {
            fg = '#e8ee30',
            bg = 'NONE',
            gui = 'NONE'
        },

        virt_text_params = {
            string_before = string.rep(' ', 4)
        },
    },

    verified_update = function ()
        if vim.tbl_contains(LatexWriter.config.apply_on_filetypes, vim.bo.filetype) then
            LatexWriter.update()
            print("Written")
        end
    end,

    update = function ()
        local items = search_in_buffer()
        for i, item in ipairs(items) do
            items[i].text = parser.get_latex_text(item.text, LatexWriter.parser_path)
        end
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
        display_virtual_text(items, LatexWriter.config)
    end,

    remove = function ()
        vim.api.nvim_buf_clear_namespace(0, -1, 0, -1)
    end,

    ---@private
    _toggle_automation = function()
        if LatexWriter.augroup then
            vim.api.nvim_clear_autocmds({group = LatexWriter.augroup})
        else
            LatexWriter._set_auto_cmds()
        end
    end,

    ---@private
    _set_user_cmds = function ()
        vim.api.nvim_create_user_command('LatexWriterForce', function () LatexWriter.update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterShow', function () LatexWriter.verified_update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterToggleAuto', function () LatexWriter.verified_update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterRemove', function () LatexWriter.remove() end, {nargs = 0})
    end,

    ---@private
    _set_auto_cmds = function ()
        LatexWriter.augroup = vim.api.nvim_create_augroup("LatexWriter", { clear = true })
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

local test = LatexWriter.setup({})
--print(test.plugin_path, test.parser_path)


return LatexWriter
