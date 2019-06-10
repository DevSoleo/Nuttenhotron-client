function split(str, delim)
    local t = {}

    for sub_str in string.gmatch(str, "[^" .. delim .. "]*") do
        if sub_str ~= nil and string.len(sub_str) > 0 then
            table.insert(t, sub_str)
        end
    end

    return t
end

function splitByChunk(text, chunkSize)
	text = tostring(text)
    local s = {}

    for i=1, #text, chunkSize do
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end

    return s
end

function uncrypt(k)
	local s = splitByChunk(k, 2)
	local c = ""

	local t = {"tk", "u4", "0k", "2s", "ny", "dy", "9l", "nn", "31", "rm"}

	for i,v in ipairs(s) do
	    c = c .. getArrayIndex(t, v)
	end

	return tostring(c)
end