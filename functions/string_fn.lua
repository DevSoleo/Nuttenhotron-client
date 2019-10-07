function str_split(str, delim)
    local t = {}

    for sub_str in string.gmatch(str, "[^" .. delim .. "]*") do
        if sub_str ~= nil and string.len(sub_str) > 0 then
            table.insert(t, sub_str)
        end
    end

    return t
end

function str_split_chunk(text, chunkSize)
    text = tostring(text)
    local s = {}

    for i=1, #text, chunkSize do
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end

    return s
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function str_split_chunk(text, chunkSize)
	text = tostring(text)
    local s = {}

    for i=1, #text, chunkSize do
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end

    return s
end

-------------------------------------------------------------------------------------------------

function uncrypt(str, key)
    str = str_split_chunk(str, 1)

    if key == nil then
        key = "Eh8o0gPYCuMjqQWNa7l2KvViTn4RXwr9k6yDztxUSBbedsZO5FcpmHJGL3IfA1"
    end

    key = str_split_chunk(key, 1)

    local alphabet = "qjP9cEtk1yxDf8UaFuMghGYzVJRnlCW5mL26Zpi0THsrB34XdSIvbQ7eAOwoKN"
    alphabet = str_split_chunk(alphabet, 1)

    local result = ""

    for i=1, array_size(str) do
        local l = alphabet[array_search(key, str[i])]

        if l ~= nil then
            result = result .. l
        else
            result = result .. str[i]
        end
    end

    return result
end