function readKey(key, stade)
	local mission = nil

	if string.find(key, " ") then
		mission = split(key, " ")[tonumber(stade)]
	else
		mission = key
	end

	local mission_type = string.sub(mission, 1, 1)
	local setting = string.sub(mission, 2)

	local max_stade = getArraySize(split(key, " "))

	return {mission_type=mission_type, setting=setting, max_stade=max_stade}
end