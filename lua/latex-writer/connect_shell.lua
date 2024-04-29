
vim.cmd([[
if has('python')
    python << EOF
       print("python works")
EOF
endif
]])

return function (path, command)
    local handle = io.popen(path, 'r')
    command = 'perl ' .. path .. ' < <(echo "' .. command ..'")' .. vim.fn.shellescape(command)
    print(command)

    if handle then
        local output = handle:read("*a")
        handle:close()

        if output == nil or output == '' then
            print("No output from script or error occurred.")
            print("Script path: " .. path)
            print("Script CMD:" .. command)
        else
            print("Output from script: " .. output)
        end
    else
        print("Failed to execute script.")
    end
end
