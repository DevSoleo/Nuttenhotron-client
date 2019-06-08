-- Lorsqu'un joueur rejoint/quitte le groupe cet évènement se déclenche
local on_party_change = CreateFrame("Frame")
on_party_change:RegisterEvent("PARTY_MEMBERS_CHANGED")
on_party_change:SetScript("OnEvent", function(self, event, ...) 

end)

-- Lorsqu'un message est envoyé dans le tchat de guilde cet évènement se déclenche
local onGuildMessage = CreateFrame("Frame")
onGuildMessage:RegisterEvent("CHAT_MSG_GUILD", "CHAT_MSG_WHISPER") -- CHAT_MSG_SAY
onGuildMessage:SetScript("OnEvent", function(self, event, message, sender, ...)
	if sender == "Soleo" or sender == "Drubos" or "Aniwen" or sender == "Malacraer" or sender == "Binoom" or sender == "Lethar" then
		if string.find(message, "Clé d'évènement : ") then
			-- On "clear" les variables déjà présentes
			vSave("key", "")
			vSave("isStarted", false)
			-- vSave("rewards", {})

			-- On efface les missions déjà présentes dans le journal
			for i=1, table.getn(getLines()) do
			   getLine(i):Hide()

			    if getLine(i)["sub"] ~= nil then
					getLine(i)["sub"]:Hide()
			    end
			end

			-- On joue un son qui annonce le début de l'event
			PlaySound("ReadyCheck", "SFX")

			-- On enregistre la clé reçue par message et on définit isStarted = true
			vSave("key", string.gsub(message, "Clé d'évènement : ", ""))
			vSave("isStarted", true)
			vSave("stade", 1)

			-- On affiche les récompenses sur le journal
			displayRewards(vGet("rewards"))

			-- On affiche le journal
			NuttenhClient.main_frame:Show()
			NuttenhClient.main_frame.reward:Show()
			
			-- Le joueur réponds qu'il sera présent pour l'event (la réponse est automatique)
			SendChatMessage("[" .. NuttenhClient.addonName .. "] " .. UnitName("player") .. " participe à l'event !", "GUILD")
		elseif string.find(message, "---- Départ de l'évènement dans .... 1 ----") then
			PlaySound("RaidWarning", "SFX")
				
			wait(1.3, function()
				-- L'évènement commence ici
				startMission(_Client["key"], 1)
			end)
		elseif string.find(message, "---- Départ de l'évènement dans ....") then
			PlaySound("RaidWarning", "SFX")
		elseif string.find(message, "L'évènement est terminé !") ~= nil then
			if vGet("isStarted") == true then
				-- On actualise l'affichage, en remettant tout à zéro
				NuttenhClient.main_frame.statusbar:SetValue(0)
				NuttenhClient.main_frame.statusbar.value:SetText("0%")

				-- On arrête l'évènement en réinitialisant toutes les variables
				vSave("isStarted", false)
				vSave("key", "")
				vSave("stade", 0)

				-- On efface les missions déjà présentes dans le journal
				for i=1, table.getn(getLines()) do
				   getLine(i):Hide()

				    if getLine(i)["sub"] ~= nil then
						getLine(i)["sub"]:Hide()
				    end
				end

				print("")
				-- ATTENTION
				vSave("rewards", nil)
				vSave("rewards", {})

				-- On masque les récompenses
				NuttenhClient.main_frame.reward:Hide()
			else
				-- On masque le journal (et la question en cours si il y en a une)
				NuttenhClient.main_frame:Hide()
				StaticPopup_Hide("QUESTION")
			end
		elseif string.find(message, "a ajouté") and string.find(message, "en récompense !") then
			local amount = 5
			local id = nil

			-- On récupère l'ID de l'item ajouté en récompense
			string.gsub(message, "%((.-)%)", function(o)
				id = o
			end)

			-- On précharge l'item demandé
			GetItemInfo(id)

			-- On ajoute l'item dans la liste des récompenses
			if getArraySize(vGet("rewards")) == nil or getArraySize(vGet("rewards")) == 0 then
				vSave("rewards", {})

				local rewards = {}

				rewards[0] = {id=id, amount=amount}

				vSave("rewards", rewards)
			else
				_Client["rewards"][getArraySize(vGet("rewards"))] = {id=id, amount=amount}
			end
		elseif string.find(message, " a retiré une récompense.") then -- Lorsque une récompense est retirée
			-- On retire cette récompense de la liste
			_Client["rewards"][getArraySize(vGet("rewards"))] = nil
		elseif string.find(message, "Date maximale de fin : ") then
			-- On affiche l'heure de fin de l'event
			vSave("endTime", string.gsub(message, "Date maximale de fin : ", ""))
		end
	end
end)

-- Lorsque l'addon est (re)chargé cet évènement se déclenche
local o = CreateFrame("Frame")
o:RegisterEvent("ADDON_LOADED")
o:SetScript("OnEvent", function(self, event, ...)
	-- Si un évent est en cours
	if vGet("isStarted") == true then
		if vGet("isStarted") ~= "" and _Client["stade"] ~= 0 and _Client["key"] ~= nil and _Client["stade"] ~= nil then
			-- On affiche le journal et on actualise la barre de progression
			NuttenhClient.main_frame:Show()
			NuttenhClient.main_frame.statusbar:SetValue(tonumber(_Client["stade"]) * 20)
			NuttenhClient.main_frame.statusbar.value:SetText(tostring(tonumber(_Client["stade"]) * 20) .. "%")

			for i=1, tonumber(_Client["stade"]) - 1 do
				addDescLine(i)
			end

			displayRewards(_Client["rewards"])

			startMission(_Client["key"], _Client["stade"])
		else
			_Client["key"] = ""
			_Client["stade"] = 0
		end
	else
		NuttenhClient.main_frame.reward:Hide()
	end

	if _Client["endTime"] ~= nil then
		local endTime = vGet("endTime")
		endTime = string.gsub(endTime, "h", "")

		print(endTime)
	end

	o:UnregisterEvent("ADDON_LOADED")
end)