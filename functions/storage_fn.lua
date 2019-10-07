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
	wait(0.1, vSave("goldReward", 0))
	wait(0.1, vSave("GM", ""))
	wait(0.1, vSave("maxTime", ""))
	wait(0.1, vSave("isLate", false))
end