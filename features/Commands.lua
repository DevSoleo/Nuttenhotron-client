-- Définitions du nom des commandes
SLASH_COORDS1 = "/coords"
SLASH_PARTICIPER1 = "/participer"

-- On créer la fonction déclenchée lorsque la commande /coords est utilisée
SlashCmdList["COORDS"] = function(msg)
	print("x : " .. getPlayerCoords()["x"] .. ", y : " .. getPlayerCoords()["y"])
end

-- On créer la fonction déclenchée lorsque la commande /participer est utilisée
SlashCmdList["PARTICIPER"] = function(msg)
	if vGet("isStarted") ~= true then
		SendChatMessage(UnitName("player") .. " souhaite aussi participer à l'event !", "GUILD")
	end
end