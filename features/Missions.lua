-- Cette fonction se déclenche lorsqu'un joueur termine l'event
function finishAllMissions(isWinner)
	local eventKey = vGet("key")

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

		DoEmote("victory")

		-- On génère ici la clé de victoire
		local time = str_split_chunk(time(), 1)
		local result = ""

		local alphabet = {"N", "Y", "e", "F", "g", "H", "G", "D", "a"}
		alphabet[0] = "i"

		for i=1, array_size(time) - 4 do
		   result = result .. alphabet[tonumber(math.random(0, 9))]
		end

		for i=1, array_size(time) do
		   if i > array_size(time) - 4 then
		      result = result .. alphabet[tonumber(time[i])]
		   end
		end

		vSave("isWinner", true)

		SendChatMessage("---- " .. UnitName("player") .. " a gagné ! Clé de victoire : " .. result .. " ----", "GUILD")
	end
end

function startMission(key, stade)
	-- On actualise le stade
	vSave("stade", stade)

	-- On actualise la scrollbar
	if vGet("stade") <= 6 then
		NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:Hide()
	else
		NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:Show()
		NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetMinMaxValues(1, 7 + (tonumber(vGet("stade")) - 7) * 35 + 12)
		wait(1, NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetValue(7 + (tonumber(vGet("stade")) - 7) * 35 + 12)) 
	end

	PlaySound("QUESTADDED", "SFX")

	-- On récupère le nombre de missions présentes dans la clé
	-- Le divisant le nombre de caractère par deux (une mission = 2 caractères)
	local maxStade = array_size(str_split(vGet("key"), " "))
	local mission = nil

	if stade > maxStade then
		finishAllMissions(true)
	else
		if string.find(key, " ") then
			mission = str_split(key, " ")[tonumber(vGet("stade"))]
		else
			mission = vGet("key")
		end

		local mission_type = string.sub(mission, 1, 1)
		local setting = string.sub(mission, 2)
		if stade <= maxStade then

			displayNewMission()

			if mission_type == "1" then
			  	local t = CreateFrame("Frame")
				t:RegisterEvent("UNIT_TARGET")
				t:SetScript("OnEvent", function(pUnit, ...)
					if UnitGUID("target") ~= nil then
						if tostring(UnitName("target")):sub(1, -1) == tostring(uncrypt(TARGETS_LIST[setting]["npc_name"])) then 
							if get_target_type(UnitGUID("target")) == "player" or get_target_type(UnitGUID("target")) == "npc" then
								t:UnregisterEvent("UNIT_TARGET")

						  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
								NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
						  		startMission(key, stade + 1)
						  	end
						end
					end
				end)
			elseif mission_type == "2" then
				local lastUpdate = 0
				local is = true

				local onUpdate = CreateFrame("Frame")
				onUpdate:SetScript("OnUpdate", function(self, elapsed)
				    lastUpdate = lastUpdate + elapsed;

				    if lastUpdate > 0.1 and not WorldMapFrame:IsVisible() then

				        -- Début /0.1s
				        if is == true then
				            local margin = tonumber(uncrypt(CLIENT_LOCATIONS_LIST[setting]["margin"]))
				            local x = round(getPlayerCoords()["x"], 3)
				            local y = round(getPlayerCoords()["y"], 3)
				            local zoneText = GetZoneText()

				            local px = CLIENT_LOCATIONS_LIST[setting]["x"]
				            local py = CLIENT_LOCATIONS_LIST[setting]["y"]
				            local pZoneText = uncrypt(CLIENT_LOCATIONS_LIST[setting]["zone"])

				            local minPx = px - margin
				            local maxPx = px + margin

				            local minPy = py - margin
				            local maxPy = py + margin
				            
				            if x >= minPx and x <= maxPx and y >= minPy and y <= maxPy and zoneText == pZoneText then 
				                is = false

	                            NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
	                            NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
	                            startMission(key, stade + 1)
				            end
				        else
				        	self:Hide()
				        end

				        lastUpdate = 0;
				    end
				end)
			elseif mission_type == "3" then
				local reqItemId = tonumber(uncrypt(CLIENT_ITEMS_LIST[setting]["item_id"]))

				local lastUpdate = 0
				local is = true

				local onUpdate = CreateFrame("Frame")
				onUpdate:SetScript("OnUpdate", function(self, elapsed)
				    lastUpdate = lastUpdate + elapsed;

				    if lastUpdate > 0.1 then
						
						-- Début /0.1s
				    	if is == true then
					        getSubLine(vGet("stade")):SetText("- Compteur : " .. GetItemCount(reqItemId) .. "/" .. CLIENT_ITEMS_LIST[setting]["amount"])

					        if GetItemCount(reqItemId) >= tonumber(CLIENT_ITEMS_LIST[setting]["amount"]) then
					        	is = false

					            NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
					            NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
					            startMission(key, stade + 1)
					        end
				        else
				        	self:Hide()
				        end

				        lastUpdate = 0;
				    end
				end)
			elseif mission_type == "4" then
				local kills = 0

				if vGet("kills") ~= nil and vGet("kills") ~= 0 then
					kills = vGet("kills")
				end

				local i = CreateFrame("Frame")
				i:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "UNIT_DESTROYED", "UNIT_DIED")
				i:SetScript("OnEvent", function(self, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, killedMobName, destRaidFlags)
					if sourceName == UnitGUID("player") and hideCaster == "PARTY_KILL" and killedMobName == uncrypt(CLIENT_KILLS_LIST[setting]["mob_name"]) then
						kills = kills + 1
						vSave("kills", kills)

						if kills <= tonumber(uncrypt(CLIENT_KILLS_LIST[setting]["amount"])) then
							RaidNotice_AddMessage(RaidBossEmoteFrame, "|cFFffb923" ..  uncrypt(CLIENT_KILLS_LIST[setting]["mob_name"]) .." tué(e)s : ".. kills .. "/" .. uncrypt(CLIENT_KILLS_LIST[setting]["amount"]), ChatTypeInfo["COMBAT_XP_GAIN"]);
							-- print(kills .. "/" .. uncrypt(KILLS_LIST[setting]["amount"]))
							getSubLine(stade):SetText("- Compteur : " .. kills .. "/" .. uncrypt(CLIENT_KILLS_LIST[setting]["amount"]))
						end

						if uncrypt(CLIENT_KILLS_LIST[setting]["mob_name"]) == killedMobName and kills == tonumber(uncrypt(CLIENT_KILLS_LIST[setting]["amount"])) then
					  		NuttenhClient.main_frame.statusbar:SetValue(stade * 100 / maxStade)
							NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(stade * 100 / maxStade)) .. "%")
				
							vSave("kills", 0)
					  		
					  		startMission(key, stade + 1)
						end
					end
				end)
			elseif mission_type == "6" then
				getRandomItems(NuttenhClient.memo.boxes / 2)
			end
		end
	end
end

function getIndication(mission_type, setting)
	if mission_type == "1" then
		return "Cibler : " .. uncrypt(TARGETS_LIST[setting]["npc_name"])
	elseif mission_type == "2" then
		return "Trouver : " .. uncrypt(CLIENT_LOCATIONS_LIST[setting]["location_name"])
	elseif mission_type == "3" then
		return "Posséder : x" .. CLIENT_ITEMS_LIST[setting]["amount"] .. " " .. uncrypt(CLIENT_ITEMS_LIST[setting]["item_name"])
	elseif mission_type == "4" then
		return "Tuer : x" .. uncrypt(CLIENT_KILLS_LIST[setting]["amount"]) .. " " .. uncrypt(CLIENT_KILLS_LIST[setting]["mob_name"])
	elseif mission_type == "5" then
		return "Répondez à la question suivante :"
	elseif mission_type == "6" then
		return "Mini-jeu : " .. GAMES_LIST[setting]["name"]
	end
end

function getSubIndication(mission_type, setting)
	if mission_type == "1" then
		return uncrypt(TARGETS_LIST[setting]["indication"])
	elseif mission_type == "2" then
		return uncrypt(CLIENT_LOCATIONS_LIST[setting]["indication"])
	elseif mission_type == "4" then 
		return "Compteur : 0/" .. uncrypt(CLIENT_KILLS_LIST[setting]["amount"])
	elseif mission_type == "6" then
		return GAMES_LIST[setting]["name"]
	else
		return ""
	end
end