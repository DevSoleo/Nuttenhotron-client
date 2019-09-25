SLASH_PARTICIPER1 = "/participer"

SlashCmdList["PARTICIPER"] = function(msg)
	if vGet("isStarted") == false then
		SendChatMessage("Retardataire ".. UnitName("player") .. " souhaite aussi participer à l'event !", "GUILD")
	else
		print("|cfff050f3Vous êtes déjà inscrit dans un event !")
	end
end