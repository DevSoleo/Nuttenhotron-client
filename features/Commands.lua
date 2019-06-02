SLASH_COORDS1 = "/coords"
SLASH_HERE1 = "/here"

SlashCmdList["COORDS"] = function(msg)
	print("x : " .. getPlayerCoords()["x"] .. ", y : " .. getPlayerCoords()["y"])
end

SlashCmdList["HERE"] = function(msg)
	SendChatMessage(UnitName("player") .. " sera présent pour l'event !", "GUILD")
end