function finishAllMissions(key, winnerName)
	statusbar:SetValue(0)
	statusbar.value:SetText("0%")

	vSave("key", "")
	vSave("isStarted", false)
	vSave("stade", 0)

	for i=1, getArraySize(missions_lines_array) do
	    missions_lines_array[i]:Hide()

	    if missions_lines_array[i]["sub"] ~= nil then
			missions_lines_array[i]["sub"]:Hide()
	    end
	end
	
	reward_frame:Hide()

	SendChatMessage(winnerName .. " est le vainqueur de cet évènement !!! Voici sa clé de victoire : ", "GUILD")
end

function startMission(key, stade)
	_Client["stade"] = stade

	addDescLine(stade)

	if stade > 1 then
		missions_lines_array[stade - 1]:SetText("|cFF4A4A4A" .. missions_lines_array[stade - 1]:GetText())
		
		if missions_lines_array[stade - 1]["sub"] ~= nil then
			missions_lines_array[stade - 1]["sub"]:SetText("|cFF4A4A4A" .. missions_lines_array[stade - 1]["sub"]:GetText())
		end
	end

	if isInParty() == true and stade == "5" then
		for i=0, get_array_size(get_party_player_list()) do
			print(get_party_player_list()[i])
		end
		SendChatMessage("Je suis au stade " .. stade, "PARTY")
	end

	if stade <= 5 and _Client["isStarted"] == true then
		local readed_key = readKey(key, stade)
		local mission_type = readed_key["mission_type"]
		local setting = tostring(readed_key["setting"])

		if mission_type == "1" then
		  	print("Vous devez parler à : " .. NPC_LIST[setting]["indication"])

		  	local t = CreateFrame("Frame")
			t:RegisterEvent("UNIT_TARGET")
			t:SetScript("OnEvent", function(pUnit, ...)
				if tostring(UnitName("target")):sub(1, -1) == tostring(NPC_LIST[setting]["name"]) then 
					t:UnregisterEvent("UNIT_TARGET")

			  		-- Next mission 
			  		print("|cFF00FF00Mission accomplie !")
			  		statusbar:SetValue(stade * 20)
					statusbar.value:SetText(tostring(stade * 20) .. "%")
			  		startMission(key, stade + 1)
			  	end
			end)
		elseif mission_type == "2" then
			print("Vous devez trouver : " .. LOCATIONS_LIST[setting]["indication"])

			local is = true
			local function hookPlayerMove(...)
				if is == true then
					local margin = 0.2
					local x = round(getPlayerCoords()["x"], 3)
					local y = round(getPlayerCoords()["y"], 3)
					local zoneText = getPlayerCoords()["zoneText"]

					-- local subZoneText = getPlayerCoords()["subZoneText"]

					local px = LOCATIONS_LIST[setting]["x"]
					local py = LOCATIONS_LIST[setting]["y"]
					local pZoneText = LOCATIONS_LIST[setting]["zoneText"][language]
					-- local pSubZoneText = LOCATIONS_LIST[setting]["subZoneText"]

					local minPx = px - margin
					local maxPx = px + margin

					local minPy = py - margin
					local maxPy = py + margin
					
					-- and subZoneText == pSubZoneText
					if x >= minPx and x <= maxPx and y >= minPy and y <= maxPy and zoneText == pZoneText then 
						is = false

				  		-- Next mission
				  		print("|cFF00FF00Mission accomplie !")
				  		statusbar:SetValue(stade * 20)
						statusbar.value:SetText(tostring(stade * 20) .. "%")
				  		startMission(key, stade + 1)
					end
				end
			end

			hooksecurefunc("MoveForwardStop", hookPlayerMove)
		elseif mission_type == "3" then
			local is = true
			local itemId = ITEMS_LIST[setting]["id"]
			alreadyOwned = GetItemCount(itemId)
			alreadyOwned = alreadyOwned + 0

			print("Vous devez ramasser : x" .. ITEMS_LIST[setting]["amount"] .. " " .. ITEMS_LIST[setting]["name"][GetLocale()])

			local i = CreateFrame("Frame")
			i:RegisterEvent("ITEM_PUSH")
			i:SetScript("OnEvent", function(self, ...)
				local newAmount = GetItemCount(itemId) - alreadyOwned
				
				loadLists()
				if newAmount >= ITEMS_LIST["1"]["amount"] and is == true then
			  		is = false

			  		print("|cFF00FF00Mission accomplie !")
			  		statusbar:SetValue(stade * 20)
					statusbar.value:SetText(tostring(stade * 20) .. "%")
			  		startMission(key, stade + 1)
				end
			end)
		elseif mission_type == "4" then
			print("Vous devez tuer : x" .. KILL_LIST[setting]["amount"] .. " " .. KILL_LIST[setting]["name"][GetLocale()])

			local kills = 0
			local i = CreateFrame("Frame")
			i:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UNIT_DESTROYED", "UNIT_DIED") -- CHAT_MSG_GUILD
			i:SetScript("OnEvent", function(self, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, killedMobName, destRaidFlags)
				if sourceGUID == true then
					kills = kills + 1
					if KILL_LIST[setting]["name"][GetLocale()] == killedMobName and kills == KILL_LIST[setting]["amount"] then
				  		print("|cFF00FF00Mission accomplie !")
				  		statusbar:SetValue(stade * 20)
						statusbar.value:SetText(tostring(stade * 20) .. "%")
				  		startMission(key, stade + 1)
					end
				end
			end)
		elseif mission_type == "5" then
			print("Vous devez répondre à cette question : " .. ANSWER_LIST["1"]["question"])
			
			mission_answer = ANSWER_LIST["1"]["answer"]

			StaticPopupDialogs["QUESTION"] = {
			  	text = ANSWER_LIST["1"]["question"],
			  	button1 = "Valider",
			  	button2 = "Annuler",

			  	timeout = 0,
			  	whileDead = true,
			  	hideOnEscape = false,
			  	hasEditBox = true,

			  	OnAccept = function(self)
			      	local player_answer = self.editBox:GetText():lower()

			      	if player_answer == mission_answer then
			  			-- Next mission
			  			PlaySound("LEVELUP", "SFX");
			  			print("|cFF00FF00Mission accomplie !")
			  			statusbar:SetValue(stade * 20)
						statusbar.value:SetText(tostring(stade * 20) .. "%")
			  			startMission(key, stade + 1)
			      	end
			  	end,

		  		OnCancel = function(self)
			  		-- StaticPopup_Show("QUESTION")
				end
			}

			StaticPopup_Show("QUESTION")
		elseif mission_type == "6" then

			print("Vous devez faire un /bisou !")

			local b = CreateFrame("Frame")
			b:RegisterEvent("CHAT_MSG_TEXT_EMOTE")
			b:SetScript("OnEvent", function(self, event, message, sender, ...)
				if message ~= "Vous envoyez un baiser dans le vent." and string.find(message, "Vous envoyez un baiser à") ~= nil then
			  		print("|cFF00FF00Mission accomplie !")
			  		statusbar:SetValue(stade * 20)
					statusbar.value:SetText(tostring(stade * 20) .. "%")
			  		startMission(key, stade + 1)
				end
			end)
		end
	else
		finishAllMissions(key, UnitName("player"))
	end
end