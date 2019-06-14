if _AClient == nil then
	_AClient = {}
end

function vSave(name, value)
	_AClient[name] = value
end

function vGet(name)
	return _AClient[name]
end

function vDelete(name)
	_AClient[name] = nil
end

function vClear()
	_AClient = {}
end

function vSmoothClear()
	wait(0.1, vSave("key", ""))
	wait(0.1, vSave("isStarted", false))
	wait(0.1, vSave("stade", 0))
	wait(0.1, vSave("rewards", {}))
	wait(0.1, vSave("kills", 0))
	wait(0.1, vSave("endTime", nil))
end

--[[function vDebug()
	table.foreach(_AClient, function(k, v)
		print(k .. "=" .. v)
	end)
end]]