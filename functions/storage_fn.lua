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