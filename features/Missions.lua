-- Cette fonction se déclenche lorsqu'un joueur termine l'event
function finishAllMissions(isWinner)
		-- On clear toutes les variables
	vSmoothClear()

	-- On masque supprime toutes le missions présentes dans le journal
	clearMissions()

	-- On remet à zéro la barre de progression
	NuttenhClient.main_frame.statusbar:SetValue(0)
	NuttenhClient.main_frame.statusbar.value:SetText("0%")

	-- On masque le journal
	NuttenhClient.main_frame:Hide()

	PlaySound("AuctionWindowClose", "SFX")

	if isWinner == true then
		message("|cFFFFFFFFBravo ! Vous avez terminé l'évènement.\n Si vous êtes premier, allez récupérer vos récompenses auprès d'un officier !")

		SendChatMessage("---- " .. UnitName("player") .. " a terminé l'event ! Bravo ! ----", "GUILD")
	end
end

function startMission(key, stade)
	-- On actualise le stade
	vSave("stade", stade)

	PlaySound("QUESTADDED", "SFX")

	-- On récupère le nombre de missions présentes dans la clé
	-- Le divisant le nombre de caractère par deux (une mission = 2 caractères)
	local maxStade = getArraySize(split(vGet("key"), " ")) - 1
	local mission = split(vGet("key"), " ")[vGet("stade")]

	local mission_type = string.sub(mission, 1, 1)
	local setting = string.sub(mission, 2)

	print(mission, mission_type, setting)

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

			  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
					NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
			  		startMission(key, stade + 1)
			  	end
			end)
		elseif mission_type == "2" then
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

				  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
				  		startMission(key, stade + 1)
					end
				end
			end

			hooksecurefunc("MoveForwardStop", hookPlayerMove)
		elseif mission_type == "3" then
			local reqItemId = ITEMS_LIST[setting]["id"]
					
			getSubLine(stade):SetText("- Compteur : " .. GetItemCount(reqItemId) .. "/" .. ITEMS_LIST[setting]["amount"])

			if GetItemCount(reqItemId) >= ITEMS_LIST[setting]["amount"] then
		  		wait(0.1, function()
			  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
					NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
			  		startMission(key, stade + 1)
			  	end)
			else
				local i = CreateFrame("Frame")
				i:RegisterEvent("ITEM_PUSH")
				i:SetScript("OnEvent", function(self, ...)

			  		wait(0.1, function()

						getSubLine(stade):SetText("- Compteur : " .. GetItemCount(reqItemId) .. "/" .. ITEMS_LIST[setting]["amount"])

						if GetItemCount(reqItemId) >=  ITEMS_LIST[setting]["amount"] then
					  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
							NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
					  		startMission(key, stade + 1)
							i:UnregisterEvent("ITEM_PUSH")
						end
					end)
				end)
			end
		elseif mission_type == "4" then
						local kills = 0

			if vGet("kills") ~= nil and vGet("kills") ~= 0 then
				kills = vGet("kills")
			end

			local i = CreateFrame("Frame")
			i:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UNIT_DESTROYED", "UNIT_DIED") -- CHAT_MSG_GUILD
			i:SetScript("OnEvent", function(self, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, killedMobName, destRaidFlags)
				if sourceGUID == true and killedMobName == KILL_LIST[setting]["name"][GetLocale()] then
					kills = kills + 1
					vSave("kills", kills)

					if kills <= KILL_LIST[setting]["amount"] then
						RaidNotice_AddMessage(RaidBossEmoteFrame, "|cFFffb923" ..  KILL_LIST[setting]["name"][GetLocale()] .." tué(e)s : ".. kills .. "/" .. KILL_LIST[setting]["amount"], ChatTypeInfo["COMBAT_XP_GAIN"]);
						print(kills .. "/" .. KILL_LIST[setting]["amount"])
						getSubLine(stade):SetText("- Compteur : " .. kills .. "/" .. KILL_LIST[setting]["amount"])
					end

					if KILL_LIST[setting]["name"][GetLocale()] == killedMobName and kills == KILL_LIST[setting]["amount"] then
				  		-- print("|cFF00FF00Mission accomplie !")
				  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
			
						vSave("kills", 0)
				  		
				  		startMission(key, stade + 1)
					end
				end
			end)
		end
	end
end

function getIndication(mission_type, setting)
	if mission_type == "1" then
		return "Cibler : " .. NPC_LIST[setting]["name"][GetLocale()]
	elseif mission_type == "2" then
		return "Trouver : " .. LOCATIONS_LIST[setting]["zoneText"][GetLocale()]
	elseif mission_type == "3" then
		return "Posséder : x" .. ITEMS_LIST[setting]["amount"] .. " " .. ITEMS_LIST[setting]["name"][GetLocale()]
	elseif mission_type == "4" then
		return "Tuer : x" .. KILL_LIST[setting]["amount"] .. " " .. KILL_LIST[setting]["name"][GetLocale()]
	end
end

function getSubIndication(mission_type, setting)
	if mission_type == "1" then
		return NPC_LIST[setting]["indication"]
	elseif mission_type == "2" then
		return LOCATIONS_LIST[setting]["indication"]
	elseif mission_type == "3" then
		return ITEMS_LIST[setting]["indication"]
	elseif mission_type == "4" then 
		return KILL_LIST[setting]["indication"]
	end
end