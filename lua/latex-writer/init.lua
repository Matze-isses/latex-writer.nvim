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

LatexWriter = {
    ---@private
    plugin_path = get_plugin_path(),

    ---@private
    parser_path = nil,

    ---@private
    augroup = nil,

    --- Table to set the configuration parameters
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
            string_before = string.rep(' ', 4),
            mark_at_signcolumn = true
        },
    },

    verified_update = function ()
        if vim.tbl_contains(LatexWriter.config.apply_on_filetypes, vim.bo.filetype) then
            LatexWriter.update()
            print("Written Latex Text")
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
        if LatexWriter.augroup ~= nil then
            vim.api.nvim_clear_autocmds({group = LatexWriter.augroup})
            LatexWriter.augroup = nil
            print("Automation Off")
        else
            LatexWriter._set_auto_cmds()
            print("Automation On")
        end
    end,

    ---@private
    _set_user_cmds = function ()
        vim.api.nvim_create_user_command('LatexWriterForce', function () LatexWriter.update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterStart', function () LatexWriter.verified_update() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterToggleAuto', function () LatexWriter._toggle_automation() end, {nargs = 0})
        vim.api.nvim_create_user_command('LatexWriterRemove', function () LatexWriter.remove() end, {nargs = 0})
    end,

    ---@private
    _set_auto_cmds = function ()
        LatexWriter.augroup = vim.api.nvim_create_augroup("LatexWriter", { clear = false })
        vim.api.nvim_create_autocmd({"TextChangedI", "BufWritePost"}, {
            group=LatexWriter.augroup,
            callback = function ()
                LatexWriter.verified_update()
                print("Callback Called")
            end,
        })
    end,

    init = function (opts)
        LatexWriter.setup(opts)
    end
}

function LatexWriter.setup(opts)
    opts = opts or {}
    LatexWriter = setmetatable(LatexWriter, {config = opts})

    if LatexWriter.config.autocmds == true then LatexWriter._set_auto_cmds() end
    if LatexWriter.config.usercmds == true then LatexWriter._set_user_cmds() end

    -- There must be a better solution then this one
    LatexWriter.plugin_path, LatexWriter.parser_path = get_plugin_path()

    local hl = LatexWriter.config.highlighting
    vim.cmd('highlight LatexWriter' .. ' guifg=' .. hl.fg .. ' guibg=' .. hl.bg .. ' gui=' .. hl.gui)

    return LatexWriter
end


return LatexWriter
