local onWhisperMessage = CreateFrame("Frame")
onWhisperMessage:RegisterEvent("CHAT_MSG_WHISPER")
onWhisperMessage:SetScript("OnEvent", function(self, event, message, sender, ...)
	if sender == "Soleo" or sender == "Maladina" or sender == "Drubos" or sender == "Aniwen" or sender == "Malacraer" or sender == "Binoom" then
		if string.find(message, "Clé : ") then			
			-- On joue un son qui annonce le début de l'event
			PlaySound("ReadyCheck", "SFX")

			local splitedKey = str_split(message, "-")

			for i,v in ipairs(splitedKey) do
				if i == 1 then
					local key = ""
					local euh = str_split(string.gsub(v, "Clé : ", ""), " ")

					for ia,va in ipairs(euh) do
					    key = key .. " " .. uncrypt(va)
					end

					key = key:gsub("%µ", " "):gsub("%$", " "):gsub("%^", " "):gsub("%@", " "):gsub("%}", " "):gsub("%#", " "):gsub("%{", " "):gsub("%&", " "):gsub("%¤", " "):gsub("%°", " ")

					key = trim(key)

					-- On enregistre la clé
					vSave("key", key)
				elseif i == 2 then
					vSave("GM", v)
				elseif i == 3 then
					vSave("maxTime", v)
				end
			end

			-- On définit l'event comme : démarré
			vSave("isStarted", true)

			-- Le joueur réponds qu'il sera présent pour l'event (la réponse est automatique)
			SendChatMessage("[" .. NuttenhClient.addonName .. "] " .. UnitName("player") .. " participe à l'event !", "GUILD")

			-- On affiche le journal
			NuttenhClient.main_frame:Show()

			-- On affiche les récompenses dans le journal
			displayRewards()

			if vGet("isLate") == true then
				NuttenhClient.main_frame.noReward:SetText("Pour connaître les récompenses \n demandez à un officier.")	
			end

			-- L'évènement commence ici
			startMission(vGet("key"), 1)
		elseif string.find(message, "Accès temporaire : ") then
			local key = string.gsub(message, "Accès temporaire : ", "")

			vSave("proof-key", key)

			vSave("proof-maxtime", time() + 600)
		end
	end
end)

-- Lorsqu'un message est envoyé dans le tchat de guilde cet évènement se déclenche
local onGuildMessage = CreateFrame("Frame")
onGuildMessage:RegisterEvent("CHAT_MSG_GUILD") -- CHAT_MSG_SAY
onGuildMessage:SetScript("OnEvent", function(self, event, message, sender, ...)
	if sender == "Soleo" or sender == "Maladina" or sender == "Drubos" or sender == "Aniwen" or sender == "Malacraer" or sender == "Binoom" then
		if string.find(message, "Clé d'évènement : ") then
			-- On joue un son qui annonce le début de l'event
			PlaySound("ReadyCheck", "SFX")

			-- On récupère la clé reçue par message
			local splitedMessage = str_split(string.gsub(message, "Clé d'évènement : ", ""), " ")
			local key = ""

			for i,v in ipairs(splitedMessage) do
			    key = key .. " " .. uncrypt(v)
			end

			key = key:gsub("%µ", " "):gsub("%$", " "):gsub("%^", " "):gsub("%@", " "):gsub("%}", " "):gsub("%#", " "):gsub("%{", " "):gsub("%&", " "):gsub("%¤", " "):gsub("%°", " ")
			
			key = trim(string.sub(key, 2))

			-- On enregistre la clé
			vSave("key", key)
			-- On définit l'event comme : démarré
			vSave("isStarted", true)
			vSave("isWinner", false)

			-- Le joueur réponds qu'il sera présent pour l'event (la réponse est automatique)
			SendChatMessage("[" .. NuttenhClient.addonName .. "] " .. UnitName("player") .. " participe à l'event !", "GUILD")
		elseif string.find(message, "Le Maître du Jeu sera : ") then
			local gm = string.gsub(message, "Le Maître du Jeu sera : ", "")
			vSave("GM", gm)
		elseif string.find(message, "Date maximale de fin : ") then
			local maxTime = string.gsub(message, "Date maximale de fin : ", "")
			vSave("maxTime", maxTime)
		elseif string.find(message, "Date de départ : ") then
			local startDate = string.gsub(message, "Date de départ : ", "")
			vSave("startDate", startDate)
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
		elseif string.find(message, "L'évènement est terminé !") then
			StaticPopupDialogs["RELOAD"] = {
				text = "L'évènement est terminé, merci de cliquer sur le bouton ci-dessous :",
				button1 = "Recharger l'interface !",

				timeout = 0,
				whileDead = true,
				hideOnEscape = false,

				OnAccept = function(self)
					-- On force l'arrêt de l'event
					finishAllMissions(false)
					ReloadUI()
				end
			}

			StaticPopup_Show("RELOAD")
		elseif string.find(message, "a ajouté") and string.find(message, "en récompense !") then
			if vGet("isStarted") == false then
				if string.find(message, "P.O.") then
					local amount = 0

					-- On récupère la quantité d'item ajouté en récompense
					string.gsub(message, "x%d+", function(o)
						amount = string.gsub(o, "x", "")
					end)

					vSave("goldReward", amount)
				else
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
			end
		elseif string.find(message, " a retiré une récompense.") then -- Lorsque une récompense est retirée
			-- On ajoute l'item dans la liste des récompenses
			local rewards = vGet("rewards")
			table.remove(rewards, array_size(rewards))

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

		-- On actualise la barre de pourcentage
  		NuttenhClient.main_frame.statusbar:SetValue((vGet("stade") - 1) * 100 / array_size(str_split(vGet("key"), " ")))
		NuttenhClient.main_frame.statusbar.value:SetText(tostring(round((vGet("stade") - 1) * 100 / array_size(str_split(vGet("key"), " ")))) .. "%")

		-- On affiche les missions effectuées
		if vGet("stade") > 1 then
			displayMissions()
		end 
		
		NuttenhClient.main_frame.noReward:Hide()
		NuttenhClient.main_frame.reward:Hide()

		if array_size(vGet("rewards")) == 0 or array_size(vGet("rewards")) == nil then
			NuttenhClient.main_frame.noReward:Show()
		else
			NuttenhClient.main_frame.reward:Show()
		end

		displayRewards()

		-- On démarre la mission qui été en cours avant le reload
		startMission(vGet("key"), vGet("stade"))

		if vGet("maxTime") ~= "" and vGet("maxTime") ~= "Aucune" then
			local date = str_split(str_split(vGet("maxTime"), " ")[1], "-")
			local time = str_split(str_split(vGet("maxTime"), " ")[2], ":")

			local year = date[1]
			local month = date[2]
			local day = date[3]


			local hour = time[1]
			local minute = time[2]
			local seconds = time[3]

			local a_year = tonumber(getServerDate("%y"))
			local a_month = tonumber(getServerDate("%m"))
			local a_day = tonumber(getServerDate("%d"))
			local a_hour = tonumber(getServerDate("%H"))
			local a_minute = tonumber(getServerDate("%M"))

			if #tostring(a_month) == 1 then
				a_month = "0" .. tostring(a_month)
			end

			if #tostring(a_day) == 1 then
				a_day = "0" .. tostring(a_day)
			end

			if #tostring(a_hour) == 1 then
				a_hour = "0" .. tostring(a_hour)
			end

			if #tostring(a_minute) == 1 then
				a_minute = "0" .. tostring(a_minute)
			end

			local final_date = year .. month .. day .. hour .. minute
			local a_fine_date = a_year .. a_month .. a_day .. a_hour .. a_minute

			if a_fine_date >= final_date then
				StaticPopupDialogs["RELOAD"] = {
					text = "L'évènement est terminé, merci de cliquer sur le bouton ci-dessous :",
					button1 = "Recharger l'interface !",

					timeout = 0,
					whileDead = true,
					hideOnEscape = false,

					OnAccept = function(self)
						-- On force l'arrêt de l'event
						finishAllMissions(false)
						ReloadUI()
					end
				}

				StaticPopup_Show("RELOAD")
			end
		end
	else
		NuttenhClient.main_frame:Hide()
		vSmoothClear()
	end
	
	onLoading:UnregisterEvent("ADDON_LOADED")
end)