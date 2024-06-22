
return function (path, command)
    command = 'perl ' .. path .. ' < <(echo \"' .. command ..'\")'

    local output = vim.fn.system(command)

    if output == nil or output == '' then
        print("No output from script or error occurred.")
        print("Script path: " .. path)
        print("Script CMD:")
        error("Missing output of Script")
    end

    return output
end
