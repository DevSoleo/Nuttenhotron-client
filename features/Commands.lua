SLASH_COORDS1 = "/coords"
-- SLASH_HERE1 = "/here"
SLASH_PARTICIPER1 = "/participer"

SlashCmdList["COORDS"] = function(msg)
	print("x : " .. getPlayerCoords()["x"] .. ", y : " .. getPlayerCoords()["y"])
end

SlashCmdList["PARTICIPER"] = function(msg)
	if _Client["isStarted"] ~= true then
		SendChatMessage(UnitName("player") .. " souhaite aussi participer à l'event !", "GUILD")
	end
end