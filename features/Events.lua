-- Lorsqu'un message est envoyé dans le tchat de guilde cet évènement se déclenche
local onGuildMessage = CreateFrame("Frame")
onGuildMessage:RegisterEvent("CHAT_MSG_GUILD", "CHAT_MSG_WHISPER") -- CHAT_MSG_SAY
onGuildMessage:SetScript("OnEvent", function(self, event, message, sender, ...)
	if sender == "Soleo" or sender == "Drubos" or sender == "Aniwen" or sender == "Malacraer" or sender == "Binoom" or sender == "Lethar" then
		if string.find(message, "Clé d'évènement : ") then
			-- On joue un son qui annonce le début de l'event
			PlaySound("ReadyCheck", "SFX")

			-- On récupère la clé reçue par message
			local splitedMessage = split(string.gsub(message, "Clé d'évènement : ", ""), " ")
			local key = ""

			for i,v in ipairs(splitedMessage) do
			    key = key .. uncrypt(v, "letterToNumber")
			end

			-- On enregistre la clé
			vSave("key", key)

			-- On définit l'event comme : démarré
			vSave("isStarted", true)

			-- Le joueur réponds qu'il sera présent pour l'event (la réponse est automatique)
			SendChatMessage("[" .. NuttenhClient.addonName .. "] " .. UnitName("player") .. " participe à l'event !", "GUILD")
		elseif string.find(message, "---- Départ de l'évènement dans ....") then
			-- On joue un son qui annonce le départ de l'event
			PlaySound("RaidWarning", "SFX")
		elseif string.find(message, "---- L'évènement Nuttenh Ayms automatisé débute ! ----") then
			-- On affiche le journal
			NuttenhClient.main_frame:Show()

			-- On affiche les récompenses dans le journal
			displayRewards()

			-- L'évènement commence ici
			startMission(vGet("key"), 1)
		elseif string.find(message, "L'évènement est terminé !") ~= nil then
			if vGet("isStarted") == true then
				-- On force l'arrêt de l'event
				finishAllMissions(false)
			end
		elseif string.find(message, "a ajouté") and string.find(message, "en récompense !") then
			if vGet("isStarted") == false then
				local amount = 0
				local id = nil

				-- On récupère l'ID de l'item ajouté en récompense
				string.gsub(message, "%((.-)%)", function(o)
					id = o
				end)

				-- On récupère la quantité d'item ajouté en récompense
				string.gsub(message, "x%d+", function(o)
					amount = string.gsub(o, "x", "")
				end)

				-- On précharge l'item demandé
				GetItemInfo(id)

				-- On ajoute l'item dans la liste des récompenses
				local rewards = vGet("rewards")
				table.insert(rewards, {id=id, amount=amount})

				vSave("rewards", rewards)
			end
		elseif string.find(message, " a retiré une récompense.") then -- Lorsque une récompense est retirée
			-- On ajoute l'item dans la liste des récompenses
			local rewards = vGet("rewards")
			table.remove(rewards, getArraySize(rewards))

			vSave("rewards", rewards)
		elseif string.find(message, "Date maximale de fin : ") then

		end
	end
end)

-- Lorsque l'addon est (re)chargé cet évènement se déclenche
local onLoading = CreateFrame("Frame")
onLoading:RegisterEvent("ADDON_LOADED")
onLoading:SetScript("OnEvent", function(self, event, ...)
	if vGet("isStarted") == true then
		-- On affiche le journal
		NuttenhClient.main_frame:Show()

		-- On affiche les missions effectuées
		displayMissions()

		-- On démarre la mission qui été en cours avant le reload
		startMission(vGet("key"), vGet("stade"))
	else
		NuttenhClient.main_frame:Hide()
		vSmoothClear()
	end
	
	onLoading:UnregisterEvent("ADDON_LOADED")
end)