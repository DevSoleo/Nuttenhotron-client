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

			for i=1, table.getn(missions_lines_array) - 1 do
			    missions_lines_array[i]:Hide()

			    if missions_lines_array[i]["sub"] ~= nil then
					missions_lines_array[i]["sub"]:Hide()
			    end
			end

			-- On joue un son qui annonce le début de l'event
			PlaySound("ReadyCheck", "SFX");

			-- On enregistre la clé reçue par message et on définit isStarted = true
			vSave("key", string.gsub(message, "Clé d'évènement : ", ""))
			vSave("isStarted", true)

			-- On affiche les récompenses sur le journal
			displayRewards(vGet("rewards"))

			main_frame:Show()
			reward_frame:Show()
			
			-- Le joueur réponds qu'il sera présent pour l'event (la réponse est automatique)
			SendChatMessage("[" .. addonName .. "] " .. UnitName("player") .. " participe à l'event !", "GUILD")

			-- L'évènement commence ici
			startMission(_Client["key"], 1)
		elseif string.find(message, "L'évènement est terminé !") ~= nil and vGet("isStarted") == true then
			statusbar:SetValue(0)
			statusbar.value:SetText("0%")

			-- On arrête l'évènement
			vSave("isStarted", false)
			vSave("key", "")
			vSave("stade", 0)
			
			main_frame:Hide()
			StaticPopup_Hide("QUESTION")

			for i=1, table.getn(missions_lines_array) do
			    missions_lines_array[i]:Hide()

			    if missions_lines_array[i]["sub"] ~= nil then
					missions_lines_array[i]["sub"]:Hide()
			    end
			end

			reward_frame:Hide()
		elseif string.find(message, "a ajouté") and string.find(message, "en récompense !") then
			local amount = 5
			local id = nil

			string.gsub(message, "%((.-)%)", function(o)
				id = o
			end)

			GetItemInfo(id)

			if getArraySize(vGet("rewards")) == nil or getArraySize(vGet("rewards")) == 0 then
				vSave("rewards", {})

				local rewards = {}

				rewards[0] = {id=id, amount=amount}

				vSave("rewards", rewards)
			else
				_Client["rewards"][getArraySize(vGet("rewards"))] = {id=id, amount=amount}
			end
		elseif string.find(message, " a retiré une récompense.") then
			_Client["rewards"][getArraySize(vGet("rewards"))] = nil
		elseif string.find(message, "Date maximale de fin : ") then
			vSave("endTime", string.gsub(message, "Date maximale de fin : ", ""))
		end
	end
end)


--[[
local onWhisperMessage = CreateFrame("Frame")
onWhisperMessage:RegisterEvent("CHAT_MSG_WHISPER") -- CHAT_MSG_SAY
onWhisperMessage:SetScript("OnEvent", function(self, event, message, sender, ...)
	if sender == "Soleo" or sender == "Drubos" or "Aniwen" or sender == "Malacraer" or sender == "Binoom" or sender == "Lethar" then
		if string.find(message, "Clé d'évènement : ") then
			-- On "clear" les variables déjà présentes
			vSave("key", "")
			vSave("isStarted", false)
			vSave("rewards", {})

			for i=1, table.getn(missions_lines_array) - 1 do
			    missions_lines_array[i]:Hide()

			    if missions_lines_array[i]["sub"] ~= nil then
					missions_lines_array[i]["sub"]:Hide()
			    end
			end

			-- On enregistre la clé reçue par message et on définit isStarted = true
			vSave("key", string.gsub(message, "Clé d'évènement : ", ""))
			vSave("isStarted", true)

			-- On affiche les récompenses sur le journal
			displayRewards(vGet("rewards"))

			main_frame:Show()
			reward_frame:Show()
			
			-- Le joueur réponds qu'il sera présent pour l'event (la réponse est automatique)
			SendChatMessage("[" .. addonName .. "] " .. UnitName("player") .. " participe à l'event !", "GUILD")

			-- L'évènement commence ici
			startMission(_Client["key"], 1)
		end
	end
end)
]]

-- Lorsque l'addon est (re)chargé cet évènement se déclenche
local o = CreateFrame("Frame")
o:RegisterEvent("ADDON_LOADED")
o:SetScript("OnEvent", function(self, event, ...) 
	if _Client["isStarted"] == true then
		if _Client["key"] ~= "" and _Client["stade"] ~= 0 and _Client["key"] ~= nil and _Client["stade"] ~= nil then
			main_frame:Show()
			statusbar:SetValue(tonumber(_Client["stade"]) * 20)
			statusbar.value:SetText(tostring(tonumber(_Client["stade"]) * 20) .. "%")

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
		reward_frame:Hide()
	end

	if _Client["endTime"] ~= nil then
		local endTime = vGet("endTime")
		endTime = string.gsub(endTime, "h", "")

		print(endTime)
	end

	o:UnregisterEvent("ADDON_LOADED")
end)