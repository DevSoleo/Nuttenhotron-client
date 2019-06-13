_Client = {}

function vSave(name, value)
	_Client[name] = value
end

function vGet(name)
	return _Client[name]
end

function vDelete(name)
	_Client[name] = nil
end

function vClear()
	_Client = {}
end

function vSmoothClear()
	wait(0.1, vSave("key", ""))
	wait(0.1, vSave("isStarted", false))
	wait(0.1, vSave("stade", 0))
	wait(0.1, vSave("rewards", {}))
	wait(0.1, vSave("kills", 0))
	wait(0.1, vSave("endTime", nil))

	for p=1, getArraySize(getLines()) - 1 do
		if getIndication(p) ~= nil then
			getIndication(p):Hide()
		end
	end
end