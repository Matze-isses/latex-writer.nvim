

return function (command)
    local script_path = vim.fn.expand("<sfile>:p:h:h") .. "/../bin/input_parser.sh"

    local handle = io.popen(script_path, 'r')

    if handle then
        local output = handle:read("*a")
        handle:close()

        if output == nil or output == '' then
            print("No output from script or error occurred.")
            print("Script path: " .. script_path)
        else
            print("Output from script: " .. output)
        end
    else
        print("Failed to execute script.")
    end
end
