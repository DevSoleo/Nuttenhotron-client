-- Cette fonction doit être déclenchée lorsqu'un joueur termine l'event
function finishAllMissions(key, winnerName)
	-- On remet à zéro la barre de progression
	NuttenhClient.main_frame.statusbar:SetValue(0)
	NuttenhClient.main_frame.statusbar.value:SetText("0%")

	-- On "clear" les toutes variables
	vSave("key", "")
	vSave("isStarted", false)
	vSave("stade", 0)

	-- On efface les missions présentes dans le journal
	for i=1, getArraySize(NuttenhClient.missions_lines_array) do
	    NuttenhClient.missions_lines_array[i]:Hide()

	    if NuttenhClient.missions_lines_array[i]["sub"] ~= nil then
			NuttenhClient.missions_lines_array[i]["sub"]:Hide()
	    end
	end
	
	-- On masque les récompenses
	NuttenhClient.reward_frame:Hide()

	SendChatMessage(winnerName .. " est le vainqueur de cet évènement !!! Voici sa clé de victoire : ", "GUILD")
end

function startMission(key, stade)
	vSave("stade", stade)

	PlaySound("QUESTADDED", "SFX");
	
	addDescLine(stade)

	-- On actualise les missions, lorsqu'elle sont terminées
	if stade > 1 then
		NuttenhClient.missions_lines_array[stade - 1]:SetText("|cFF4A4A4A" .. NuttenhClient.missions_lines_array[stade - 1]:GetText())
		
		if NuttenhClient.missions_lines_array[stade - 1]["sub"] ~= nil then
			NuttenhClient.missions_lines_array[stade - 1]["sub"]:SetText("|cFF4A4A4A" .. NuttenhClient.missions_lines_array[stade - 1]["sub"]:GetText())
		end
	end

	--[[
	if isInParty() == true and stade == "5" then
		for i=0, get_array_size(get_party_player_list()) do
			print(get_party_player_list()[i])
		end
		SendChatMessage("Je suis au stade " .. stade, "PARTY")
	end
	]]

	-- Si le joueur n'a pas fini l'event et qu'il y a un event en cours
	if stade <= 5 and _Client["isStarted"] == true then
		-- On lit la clé et on récupère le type de mission et le paramètre associé en fonction du stade
		local readed_key = readKey(key, stade)
		local mission_type = readed_key["mission_type"]
		local setting = tostring(readed_key["setting"])

		if mission_type == "1" then
		  	-- print("Vous devez parler à : " .. NPC_LIST[setting]["indication"])

		  	local t = CreateFrame("Frame")
			t:RegisterEvent("UNIT_TARGET")
			t:SetScript("OnEvent", function(pUnit, ...)
				if tostring(UnitName("target")):sub(1, -1) == tostring(NPC_LIST[setting]["name"]) then 
					t:UnregisterEvent("UNIT_TARGET")

			  		-- Next mission 
			  		-- print("|cFF00FF00Mission accomplie !")
			  		NuttenhClient.main_frame.statusbar:SetValue(stade * 20)
					NuttenhClient.main_frame.statusbar.value:SetText(tostring(stade * 20) .. "%")
			  		startMission(key, stade + 1)
			  	end
			end)
		elseif mission_type == "2" then
			-- print("Vous devez trouver : " .. LOCATIONS_LIST[setting]["indication"])

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
				  		-- print("|cFF00FF00Mission accomplie !")
				  		NuttenhClient.main_frame.statusbar:SetValue(stade * 20)
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(stade * 20) .. "%")
				  		startMission(key, stade + 1)
					end
				end
			end

			hooksecurefunc("MoveForwardStop", hookPlayerMove)
		elseif mission_type == "3" then
			local is = true
			local itemId = ITEMS_LIST[setting]["id"]
			local alreadyOwned = GetItemCount(itemId)
			alreadyOwned = alreadyOwned + 0

			-- print("Vous devez ramasser : x" .. ITEMS_LIST[setting]["amount"] .. " " .. ITEMS_LIST[setting]["name"][GetLocale()])
				
			NuttenhClient.missions_lines_array[stade]["sub"]:SetText("- Compteur : 0/" .. ITEMS_LIST["1"]["amount"])

			local i = CreateFrame("Frame")
			i:RegisterEvent("ITEM_PUSH")
			i:SetScript("OnEvent", function(self, ...)
				vSave("pickuploot", nil)

				wait(0.1, function()
					vSave("pickuploot", GetItemCount(itemId) - alreadyOwned)

					if vGet("pickuploot") <= ITEMS_LIST[setting]["amount"] then
						NuttenhClient.missions_lines_array[stade]["sub"]:SetText("- Compteur : " .. vGet("pickuploot") .. "/" .. ITEMS_LIST[setting]["amount"])
					end

					-- ICI PROBLEME
					loadLists()
					if vGet("pickuploot") >= ITEMS_LIST[setting]["amount"] and is == true then
				  		is = false

				  		-- print("|cFF00FF00Mission accomplie !")
				  		NuttenhClient.main_frame.statusbar:SetValue(stade * 20)
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(stade * 20) .. "%")
				  		startMission(key, stade + 1)

				  		i:UnregisterEvent("ITEM_PUSH")
					end
				end)
			end)
		elseif mission_type == "4" then
			-- print("Vous devez tuer : x" .. KILL_LIST[setting]["amount"] .. " " .. KILL_LIST[setting]["name"][GetLocale()])

			local kills = 0
			local i = CreateFrame("Frame")
			i:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UNIT_DESTROYED", "UNIT_DIED") -- CHAT_MSG_GUILD
			i:SetScript("OnEvent", function(self, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, killedMobName, destRaidFlags)
				if sourceGUID == true then
					kills = kills + 1
					
					if kills <= KILL_LIST[setting]["amount"] then
						print(kills .. "/" .. KILL_LIST[setting]["amount"])
					end

					if KILL_LIST[setting]["name"][GetLocale()] == killedMobName and kills == KILL_LIST[setting]["amount"] then
				  		-- print("|cFF00FF00Mission accomplie !")
				  		NuttenhClient.main_frame.statusbar:SetValue(stade * 20)
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(stade * 20) .. "%")
				  		startMission(key, stade + 1)
					end
				end
			end)
		elseif mission_type == "5" then
			-- print("Vous devez répondre à cette question : " .. ANSWER_LIST["1"]["question"])
			
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
			  			-- print("|cFF00FF00Mission accomplie !")
			  			NuttenhClient.main_frame.statusbar:SetValue(stade * 20)
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(stade * 20) .. "%")
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
			  		-- print("|cFF00FF00Mission accomplie !")
			  		NuttenhClient.main_frame.statusbar:SetValue(stade * 20)
					NuttenhClient.main_frame.statusbar.value:SetText(tostring(stade * 20) .. "%")
			  		startMission(key, stade + 1)
				end
			end)
		end
	else
		finishAllMissions(key, UnitName("player"))
	end
end