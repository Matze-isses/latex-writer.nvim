local Config = {
    state = {},
    config = {
        autocmds = false,
        usercmds = true,
        file_types = {'tex'},
        highlighting = {
            text = 'Todo',
            background = ''
        }
    },
}

---@package
---Updates the default config
function Config:set(cfg)
    if cfg then
        self.config = vim.tbl_deep_extend('force', self.config, cfg)
    end
    return self
end

---Get the config
function Config:get()
    return self.config
end

---@export Config
return setmetatable(Config, {
    __index = function(this, k)
        return this.state[k]
    end,
    __newindex = function(this, k, v)
        this.state[k] = v
    end,
})
