function getArrayIndex(array, value)
	local index = {}
  
	for k, v in pairs(array) do
		index[v] = k
	end

 	return index[value]
end

function getArraySize(array)
	if array ~= nil then
		local counter = 0

		for index in pairs(array) do
		    counter = counter + 1
		end

		return counter
	else
		return nil
	end
end

function concatArray(t1, t2)
    for i=1, #t2 do
        t1[#t1 + 1] = t2[i]
    end

    return t1
end

function shuffleTable(t)
    local rand = math.random 
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end
