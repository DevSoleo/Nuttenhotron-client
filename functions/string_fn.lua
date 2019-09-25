function split(str, delim)
    local t = {}

    for sub_str in string.gmatch(str, "[^" .. delim .. "]*") do
        if sub_str ~= nil and string.len(sub_str) > 0 then
            table.insert(t, sub_str)
        end
    end

    return t
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function splitByChunk(text, chunkSize)
	text = tostring(text)
    local s = {}

    for i=1, #text, chunkSize do
        s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end

    return s
end

function uncrypt(key, cType)
    if cType == "numberToLetter" then
    	local s = splitByChunk(key, 2)
    	local c = ""

    	local t = {"tk", "u4", "0k", "2s", "ny", "dy", "9l", "nn", "31", "rm"}
        t[0] = "kw"
        
    	for i,v in ipairs(s) do
    	    c = c .. getArrayIndex(t, v)
    	end

    	return tostring(c)
    elseif cType == "alphabetShuffle" then
        local alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
        local encAlphabet = {"u", "g", "o", "n", "b", "x", "s", "f", "t", "v", "e", "q", "d", "j", "k", "y", "h", "c", "a", "r", "z", "w", "i", "l", "p", "m", "U", "G", "O", "N", "B", "X", "S", "F", "T", "V", "E", "Q", "D", "J", "K", "Y", "H", "C", "A", "R", "Z", "W", "I", "L", "P", "M", "6", "2", "7", "1", "9", "8", "3", "4", "0", "5"}

        local letters = splitByChunk(key, 1)
        local result = ""

        for i=1, getArraySize(letters) do
            if alphabet[getArrayIndex(encAlphabet, letters[i])] ~= nil then
                result = result .. alphabet[getArrayIndex(encAlphabet, letters[i])]
            else
                result = result .. letters[i]
            end
        end

        return result
    end
end

function enc(text)
    local alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
    local encAlphabet = {"u", "g", "o", "n", "b", "x", "s", "f", "t", "v", "e", "q", "d", "j", "k", "y", "h", "c", "a", "r", "z", "w", "i", "l", "p", "m", "U", "G", "O", "N", "B", "X", "S", "F", "T", "V", "E", "Q", "D", "J", "K", "Y", "H", "C", "A", "R", "Z", "W", "I", "L", "P", "M", "6", "2", "7", "1", "9", "8", "3", "4", "0", "5"}

    local letters = splitByChunk(text, 1)
    local result = ""

    for i=1, getArraySize(letters) do
        if encAlphabet[getArrayIndex(alphabet, letters[i])] ~= nil then
            result = result .. encAlphabet[getArrayIndex(alphabet, letters[i])]
        else
            result = result .. letters[i]
        end
    end

    return result
end

--[[
function dec(key)
    local alphabet = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
    local encAlphabet = {"u", "g", "o", "n", "b", "x", "s", "f", "t", "v", "e", "q", "d", "j", "k", "y", "h", "c", "a", "r", "z", "w", "i", "l", "p", "m", "U", "G", "O", "N", "B", "X", "S", "F", "T", "V", "E", "Q", "D", "J", "K", "Y", "H", "C", "A", "R", "Z", "W", "I", "L", "P", "M", "6", "2", "7", "1", "9", "8", "3", "4", "0", "5"}

    local letters = splitByChunk(key, 1)
    local result = ""

    for i=1, getArraySize(letters) do
        if alphabet[getArrayIndex(encAlphabet, letters[i])] ~= nil then
            result = result .. alphabet[getArrayIndex(encAlphabet, letters[i])]
        else
            result = result .. letters[i]
        end
    end

    return result
end

]]