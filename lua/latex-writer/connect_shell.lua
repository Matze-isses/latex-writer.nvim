

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
        else
            print("Output from script: " .. output)
        end
    else
        print("Failed to execute script.")
    end
end
