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

	local t = {}
	t[0] = "tk"
	t[1] = "u4"
	t[2] = "0k"
	t[3] = "2s"
	t[4] = "ny"
	t[6] = "9l"
	t[7] = "nn"
	t[8] = "31"
	t[9] = "rm"
	t[10] = "dy"

	for i,v in ipairs(s) do
	    c = c .. getArrayIndex(t, v)
	end

	c = tonumber(c)
	c = c - 293943699 * 4

	return tostring(c)
end