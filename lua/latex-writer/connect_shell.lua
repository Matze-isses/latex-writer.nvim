
return function (path, command)
    command = 'perl ' .. path .. ' < <(echo "' .. command ..'")'

    local output = vim.fn.system(command)

    if type(output) == "table" then 
        for name, value in pairs(output) do print(name, value) end
    else
        print(output)
    end

    if output == nil or output == '' then
        print("No output from script or error occurred.")
        print("Script path: " .. path)
        print("Script CMD:" .. command.output)
    else
        print("Output from script: " .. output)
    end
    return output
end
