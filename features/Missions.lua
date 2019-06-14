-- Cette fonction se déclenche lorsqu'un joueur termine l'event
function finishAllMissions(key, winnerName)
	-- On clear toutes les variables
	vSmoothClear()

	-- On masque le journal
	NuttenhClient.main_frame:Hide()

	PlaySound("AuctionWindowClose", "SFX")
	message("|cFFFFFFFFBravo ! Vous avez terminé l'évènement.\n Si vous êtes premier, allez récupérer vos récompenses auprès d'un officier !")

	SendChatMessage("---- " .. winnerName .. " a terminé l'event ! Bravo ! ----", "GUILD")
end

function startMission(key, stade)
	-- On récupère le nombre de missions présentes dans la clé
	-- Le divisant le nombre de caractère par deux (une mission = 2 caractères)
	local maxStade = #key / 2

	PlaySound("QUESTADDED", "SFX");

	-- print(key, stade)

	local setting = 1

  	local onMobTarget = CreateFrame("Frame")
	onMobTarget:RegisterEvent("UNIT_TARGET")
	onMobTarget:SetScript("OnEvent", function(pUnit, ...)
		if tostring(UnitName("target")):sub(1, -1) == tostring(NPC_LIST[setting]["name"][GetLocale()]) then 
			print("ok")
			onMobTarget:UnregisterEvent("UNIT_TARGET")
	  	end
	end)
end