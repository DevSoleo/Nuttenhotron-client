-- Cette fonction se déclenche lorsqu'un joueur termine l'event
function finishAllMissions(isWinner)
	-- On masque supprime toutes le missions présentes dans le journal
	clearMissions()
	
	-- On clear toutes les variables
	vSmoothClear()

	-- On remet à zéro la barre de progression
	NuttenhClient.main_frame.statusbar:SetValue(0)
	NuttenhClient.main_frame.statusbar.value:SetText("0%")

	-- On masque le journal
	NuttenhClient.main_frame:Hide()

	PlaySound("AuctionWindowClose", "SFX")

	if isWinner == true then
		win()
	end
end

function win()
	message("|cFFFFFFFFBravo ! Vous avez terminé l'évènement.\n Si vous êtes premier, allez récupérer vos récompenses auprès d'un officier !")

	SendChatMessage("---- " .. UnitName("player") .. " a terminé l'event ! Bravo ! ----", "GUILD")
end

function startMission(key, stade)
	-- On actualise le stade
	vSave("stade", stade)

	PlaySound("QUESTADDED", "SFX")

	-- On récupère le nombre de missions présentes dans la clé
	-- Le divisant le nombre de caractère par deux (une mission = 2 caractères)
	local maxStade = #key / 2
	local mission = splitByChunk(vGet("key"), 2)[vGet("stade")]

	local mission_type = splitByChunk(mission, 1)[1]
	local setting = splitByChunk(mission, 1)[2]

	if stade > maxStade then
		finishAllMissions(true)
	end

	if stade <= maxStade then
		displayNewMission()
		if mission_type == "1" then
		  	local t = CreateFrame("Frame")
			t:RegisterEvent("UNIT_TARGET")
			t:SetScript("OnEvent", function(pUnit, ...)
				if tostring(UnitName("target")):sub(1, -1) == tostring(NPC_LIST[setting]["name"][GetLocale()]) then 
					t:UnregisterEvent("UNIT_TARGET")

			  		-- Next mission 
			  		-- print("|cFF00FF00Mission accomplie !")
			  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
					NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
			  		startMission(key, stade + 1)
			  	end
			end)
		end
	end
end

function getIndication(mission_type, setting)
	if mission_type == "1" then
		return NPC_LIST[setting]["name"][GetLocale()]
	end
end

function getSubIndication(mission_type, setting)
	if mission_type == "1" then
		return NPC_LIST[setting]["indication"]
	end
end