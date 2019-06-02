function getServerDate(args)
	local hour, minute = GetGameTime()
	local weekday, month, day, year = CalendarGetDate()

	args = string.gsub(args, "%%M", minute)
	args = string.gsub(args, "%%H", hour)
	args = string.gsub(args, "%%m", month)
	args = string.gsub(args, "%%d", day)
	args = string.gsub(args, "%%y", year)

	return args
end

local wait_table = {}
local wait_frame = nil

function wait(delay, func, ...)
	if type(delay) ~= "number" or type(func) ~= "function" then
		return false
	end

	if wait_frame == nil then
		wait_frame = CreateFrame("Frame", "wait_frame", UIParent)
	    wait_frame:SetScript("OnUpdate", function(self, elapse)
	      	local count = #wait_table
	      	local i = 1

	    	while i <= count do
		    	local wait_record = tremove(wait_table, i)
		        local d = tremove(wait_record, 1)
		        local f = tremove(wait_record, 1)
		        local p = tremove(wait_record, 1)

		        if d > elapse then
		        	tinsert(wait_table, i, {d - elapse, f, p})
		        	i = i + 1
		        else
		        	count = count - 1
		        	f(unpack(p))
		        end
	      	end
		end)
	end
  
  	tinsert(wait_table, {delay, func, {...}})

	return true
end