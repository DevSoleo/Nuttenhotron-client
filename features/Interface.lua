-- On crée la fenêtre principale
NuttenhClient.main_frame = CreateFrame("Frame", nil, UIParent)
NuttenhClient.main_frame:SetFrameStrata("BACKGROUND") -- Définit le z-index de la frame sur le niveau le plus bas (BACKGROUND)
NuttenhClient.main_frame:SetMovable(true) -- Permet le déplacement de la fenêtre
NuttenhClient.main_frame:EnableMouse(true)
NuttenhClient.main_frame:RegisterForDrag("LeftButton") -- Définit le clic gauche comme le bouton à utiliser pour déplacer la fenêtre
NuttenhClient.main_frame:SetScript("OnDragStart", NuttenhClient.main_frame.StartMoving)
NuttenhClient.main_frame:SetScript("OnDragStop", NuttenhClient.main_frame.StopMovingOrSizing)
NuttenhClient.main_frame:SetWidth(300)
NuttenhClient.main_frame:SetHeight(450)
NuttenhClient.main_frame:SetFrameLevel(0)
NuttenhClient.main_frame:SetPoint("TOP", 20, -20)

NuttenhClient.main_frame:SetBackdrop({
	bgFile="Interface\\Addons\\wow-event-addon-client\\textures\\UI-Background",
	edgeFile="Interface/DialogFrame/UI-DialogBox-Border",
	tile=false,
	tileSize=64, 
	edgeSize=16, 
	insets={
		left=4,
		right=4,
		top=4,
		bottom=4
	}
})

-- NuttenhClient.main_frame:Hide()

-- Close button
NuttenhClient.main_frame.close_button = CreateFrame("Button", "NuttenhClient_MainFrame_CloseButton", NuttenhClient.main_frame, "GameMenuButtonTemplate")
NuttenhClient.main_frame.close_button:SetPoint("TOPRIGHT", 0, 0)
NuttenhClient.main_frame.close_button:SetFrameLevel(1)
NuttenhClient.main_frame.close_button:SetHeight(25.4)
NuttenhClient.main_frame.close_button:SetWidth(25.4)

NuttenhClient.main_frame.close_button.fontString = NuttenhClient.main_frame.close_button:CreateFontString(nil, "ARTWORK")
NuttenhClient.main_frame.close_button.fontString:SetAllPoints()
NuttenhClient.main_frame.close_button.fontString:SetFont("Fonts\\FRIZQT__.TTF", 20)
NuttenhClient.main_frame.close_button.fontString:SetTextColor(255, 255, 0, 1)
NuttenhClient.main_frame.close_button.fontString:SetShadowOffset(1, -1)
NuttenhClient.main_frame.close_button.fontString:SetText("-")

local isMinimized = false

NuttenhClient.main_frame.close_button:SetScript("OnClick", function(self, arg1)
	if isMinimized == false then
		NuttenhClient.main_frame:SetHeight(60)
		NuttenhClient.main_frame.mission_list:Hide()
		NuttenhClient.main_frame.rewardTitle:Hide()
		NuttenhClient.main_frame.noReward:Hide()
		NuttenhClient.main_frame.reward:Hide()
		NuttenhClient.main_frame.goldReward:Hide()

		NuttenhClient.main_frame.close_button.fontString:SetText("+")
		NuttenhClient.main_frame.close_button.fontString:SetFont("Fonts\\FRIZQT__.TTF", 16)

		PlaySound("igQuestLogOpen", "SFX")

		isMinimized = true
	else
		NuttenhClient.main_frame:SetHeight(450)
		NuttenhClient.main_frame.mission_list:Show()

		if getArraySize(NuttenhClient.main_frame.itemList) == 0 and vGet("goldReward") == 0 or vGet("goldReward") == nil then
			NuttenhClient.main_frame.noReward:Show()
		else 
			NuttenhClient.main_frame.rewardTitle:Show()
			NuttenhClient.main_frame.reward:Show()
			NuttenhClient.main_frame.goldReward:Show()
			NuttenhClient.main_frame.noReward:Hide()
		end


		NuttenhClient.main_frame.close_button.fontString:SetText("-")

		PlaySound("igQuestLogClose", "SFX")

		isMinimized = false
	end
end)

-- Title
NuttenhClient.main_frame.title = NuttenhClient.main_frame:CreateFontString(nil, "ARTWORK")
NuttenhClient.main_frame.title:SetFont("Fonts\\ARIALN.ttf", 15)
NuttenhClient.main_frame.title:SetPoint("TOP", 0, -10)
NuttenhClient.main_frame.title:SetText("Progression :")
NuttenhClient.main_frame.title:SetTextColor(0, 0, 0, 1)

-- Status bar
NuttenhClient.main_frame.statusbar = CreateFrame("StatusBar", nil, NuttenhClient.main_frame)
NuttenhClient.main_frame.statusbar:SetPoint("TOP", NuttenhClient.main_frame, "TOP", 0, -30)
NuttenhClient.main_frame.statusbar:SetWidth(200)
NuttenhClient.main_frame.statusbar:SetHeight(16)
NuttenhClient.main_frame.statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
NuttenhClient.main_frame.statusbar:SetStatusBarColor(0, 0.65, 0)
NuttenhClient.main_frame.statusbar:SetMinMaxValues(0, 100)
NuttenhClient.main_frame.statusbar:SetValue(0)

NuttenhClient.main_frame.statusbar.bg = NuttenhClient.main_frame.statusbar:CreateTexture(nil, "BACKGROUND")
NuttenhClient.main_frame.statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
NuttenhClient.main_frame.statusbar.bg:SetAllPoints(true)
NuttenhClient.main_frame.statusbar.bg:SetVertexColor(0, 0, 0)

NuttenhClient.main_frame.statusbar.value = NuttenhClient.main_frame.statusbar:CreateFontString(nil, "OVERLAY")
NuttenhClient.main_frame.statusbar.value:SetPoint("CENTER", NuttenhClient.main_frame.statusbar, "TOP", 0, -8)
NuttenhClient.main_frame.statusbar.value:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
NuttenhClient.main_frame.statusbar.value:SetTextColor(255, 255, 0)
NuttenhClient.main_frame.statusbar.value:SetText("0%")

-- Mission List
NuttenhClient.main_frame.mission_list = CreateFrame("Frame", "NuttenhClient_MainFrame_MissionList", NuttenhClient.main_frame)
NuttenhClient.main_frame.mission_list:SetWidth(250)
NuttenhClient.main_frame.mission_list:SetHeight(250)
NuttenhClient.main_frame.mission_list:SetPoint("TOP", 0, -70)
NuttenhClient.main_frame.mission_list:SetBackdrop({
	edgeFile="Interface/Tooltips/UI-Tooltip-Border", 
	tile=false,
	tileSize=64, 
	edgeSize=10, 
	insets={
		left=4,
		right=4,
		top=4,
		bottom=4
	}
})

NuttenhClient.main_frame.mission_list.background = NuttenhClient.main_frame.mission_list:CreateTexture(nil, "BACKGROUND") 
NuttenhClient.main_frame.mission_list.background:SetAllPoints(NuttenhClient.main_frame.mission_list) 
NuttenhClient.main_frame.mission_list.background:SetTexture(0, 0, 0, 0.1) 

-- Mission list scroll bar
NuttenhClient.main_frame.mission_list.scrollframe = CreateFrame("ScrollFrame", nil, NuttenhClient.main_frame.mission_list) 
NuttenhClient.main_frame.mission_list.scrollframe:SetPoint("TOPLEFT", 10, -10) 
NuttenhClient.main_frame.mission_list.scrollframe:SetPoint("BOTTOMRIGHT", -10, 10)

NuttenhClient.main_frame.mission_list.scrollframe = NuttenhClient.main_frame.mission_list.scrollframe 

--scrollbar 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar = CreateFrame("Slider", nil, NuttenhClient.main_frame.mission_list.scrollframe, "UIPanelScrollBarTemplate") 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetPoint("TOPLEFT", NuttenhClient.main_frame.mission_list, "TOPRIGHT", -20, -18) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetPoint("BOTTOMLEFT", NuttenhClient.main_frame.mission_list, "BOTTOMRIGHT", -20, 18) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetMinMaxValues(1, 1) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.scrollStep = 1
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetValueStep(NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.scrollStep) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetValue(6) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetWidth(16) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetFrameLevel(1)
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetScript("OnValueChanged", function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end)

NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.background = NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:CreateTexture(nil, "BACKGROUND") 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.background:SetAllPoints(scrollbar) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.background:SetTexture(0, 0, 0, 0) 

--content frame 
NuttenhClient.main_frame.mission_list.content = CreateFrame("Frame", "ContentFrame", NuttenhClient.main_frame.mission_list.scrollframe) 
NuttenhClient.main_frame.mission_list.content:SetSize(250, 250) 

NuttenhClient.main_frame.mission_list.scrollframe:SetScrollChild(NuttenhClient.main_frame.mission_list.content)

-- Rewards Title
NuttenhClient.main_frame.rewardTitle = CreateFrame("Frame", nil, NuttenhClient.main_frame)
NuttenhClient.main_frame.rewardTitle:SetPoint("BOTTOMLEFT", 0, 60)
NuttenhClient.main_frame.rewardTitle:SetHeight(27)
NuttenhClient.main_frame.rewardTitle:SetWidth(27)

NuttenhClient.main_frame.rewardTitle.value = NuttenhClient.main_frame.rewardTitle:CreateFontString(nil, "OVERLAY")
NuttenhClient.main_frame.rewardTitle.value:SetPoint("CENTER", NuttenhClient.main_frame.rewardTitle, "TOP", 100, 20)
NuttenhClient.main_frame.rewardTitle.value:SetFont("Fonts\\MORPHEUS.ttf", 18)
NuttenhClient.main_frame.rewardTitle.value:SetTextColor(0, 0, 0, 0.8)
NuttenhClient.main_frame.rewardTitle.value:SetText("Le vainqueur remportera :")

-- Item Rewards
NuttenhClient.main_frame.reward = CreateFrame("Frame", nil, NuttenhClient.main_frame)
NuttenhClient.main_frame.reward:SetPoint("BOTTOMLEFT", 0, 60)
NuttenhClient.main_frame.reward:SetHeight(27)
NuttenhClient.main_frame.reward:SetWidth(27)

-- Gold reward

NuttenhClient.main_frame.goldReward = CreateFrame("Frame", nil, NuttenhClient.main_frame)
NuttenhClient.main_frame.goldReward:SetPoint("BOTTOMLEFT", 0, -15)
NuttenhClient.main_frame.goldReward:SetHeight(27)
NuttenhClient.main_frame.goldReward:SetWidth(10)

NuttenhClient.main_frame.goldReward.value = NuttenhClient.main_frame.goldReward:CreateFontString(nil, "OVERLAY")
NuttenhClient.main_frame.goldReward.value:SetPoint("LEFT", NuttenhClient.main_frame.goldReward, "TOP", 10, 20)
NuttenhClient.main_frame.goldReward.value:SetFont("Fonts\\FRIZQT__.ttf", 14)
NuttenhClient.main_frame.goldReward.value:SetTextColor(0, 0, 0, 0.8)
NuttenhClient.main_frame.goldReward.value:SetText("")


-- No rewards
NuttenhClient.main_frame.noReward = NuttenhClient.main_frame:CreateFontString(nil, "ARTWORK")
NuttenhClient.main_frame.noReward:SetFont("Fonts\\ARIALN.ttf", 17)
NuttenhClient.main_frame.noReward:SetPoint("BOTTOM", 0, 55)
NuttenhClient.main_frame.noReward:SetText("Les officiers n'ont déterminé \n aucune récompense pour cet évènement")
NuttenhClient.main_frame.noReward:SetTextColor(0, 0, 0, 1)

NuttenhClient.main_frame.itemList = {}

function addMissionLine(text, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetPoint("TOPLEFT", 0, 0 - ((lineNumber - 1) * 35))
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetTextColor(0, 0, 0, 1)
end

function addMissionSubLine(text, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetPoint("TOPLEFT", 15, 0 - ((lineNumber) * 35 - 20))
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)
end

-- Cette fonction sert à afficher un tooltip au passage de la souris sur la sub line
function addIndication(text, tooltip, lineNumber, tType)
	if tType == 1 then
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetPoint("TOPLEFT", 15,  0 - ((lineNumber - 1) * 35 + 20))
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetText("- " .. text)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"] = CreateFrame("Frame", nil, NuttenhClient.main_frame.mission_list.content)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetFrameStrata("BACKGROUND")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetBackdropBorderColor(255, 0, 0, 1)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetPoint("TOPLEFT", 75, 0 - ((lineNumber - 1) * 35 + 19))
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetWidth(15)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetHeight(15)

		local t = NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:CreateTexture(nil,"BACKGROUND")
		t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		t:SetAllPoints(NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"])
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"].texture = t

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetScript("OnEnter", function(self)
	  	GameTooltip:SetOwner(NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"], "ANCHOR_CURSOR")
	  	GameTooltip:SetText(tooltip)
		  	GameTooltip:Show()
		end)

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	elseif tType == 2 then
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetPoint("TOPLEFT", 15,  0 - ((lineNumber - 1) * 35 + 20))
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetText("")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"] = CreateFrame("Button", "MainFrame_MissionList_Content_Button" .. lineNumber, NuttenhClient.main_frame.mission_list.content, "GameMenuButtonTemplate")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetPoint("TOPLEFT", 5, 0 - ((lineNumber - 1) * 35 + 19))
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetWidth(90)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetHeight(20)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetText("Question")

		local readedKey = readKey(vGet("key"), vGet("stade"))
		local max_stade = readedKey["max_stade"]
		local setting = readedKey["setting"]

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetScript("OnClick", function(self)
			StaticPopupDialogs["QUESTION_1"] = {
			  	text = ANSWER_LIST[setting]["question"],
			  	
			  	button1 = "Valider",
			  	button2 = "Fermer",

			  	timeout = 0,
			  	whileDead = true,
			  	hideOnEscape = true,
			  	hasEditBox = true,
			  	enterClicksFirstButton = true,

			  	OnAccept = function(self)
			  	-- 123 TODO
					if self.editBox:GetText():lower() == uncrypt(ANSWER_LIST[setting]["answer"]:lower(), "alphabetShuffle") then
				  		NuttenhClient.main_frame.statusbar:SetValue(vGet("stade") * 100 / getArraySize(split(vGet("key"), " ")))
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(vGet("stade") * 100 / getArraySize(split(vGet("key"), " ")))) .. "%")
			  			
			  			startMission(vGet("key"), vGet("stade") + 1)
					else
						print("Réponse incorrecte !")
					end
			  	end
			}

			StaticPopup_Show("QUESTION_1")
		end)
	elseif tType == 3 then
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetPoint("TOPLEFT", 15,  0 - ((lineNumber - 1) * 35 + 20))
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetText("")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"] = CreateFrame("Button", "MainFrame_MissionList_Content_Button" .. lineNumber, NuttenhClient.main_frame.mission_list.content, "GameMenuButtonTemplate")
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetPoint("TOPLEFT", 5, 0 - ((lineNumber - 1) * 35 + 19))
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetWidth(90)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetHeight(20)
		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetText("Fermer")

		NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetScript("OnClick", function(self)
			if NuttenhClient.memo.memo_frame:IsShown() then
				NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetText("Ouvrir")
				NuttenhClient.memo.memo_frame:Hide()
			else
				NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]:SetText("Fermer")
				NuttenhClient.memo.memo_frame:Show()
			end
		end)
	end
end

function getLine(lineNumber)
	return NuttenhClient.main_frame.mission_list.content[lineNumber]
end

function getLines()
	return NuttenhClient.main_frame.mission_list.content
end

function getSubLine(lineNumber)
	if NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] ~= nil then
		return NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]
	else
		return nil
	end
end

function getIcon(lineNumber)
	if NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"] ~= nil then
		return NuttenhClient.main_frame.mission_list.content[lineNumber]["icon"]
	else
		return nil
	end
end

-- Cette fonction permet d'afficher toutes les missions effectuées SAUF celle en cours
function displayMissions()
	for i=1, vGet("stade") do		
		local readedKey = readKey(vGet("key"), i)
		local mission_type = readedKey["mission_type"]
		local setting = readedKey["setting"]

		addMissionLine("|cFF4A4A4A" .. getIndication(mission_type, setting), i)

		if i ~= vGet("stade") then
			addMissionSubLine("|cFF4A4A4ATerminé !", i)
		end
	end
end

-- Cette fonction permet d'afficher la mission en cours
function displayNewMission()
	if vGet("stade") > 1 then
		getLine(vGet("stade") - 1):SetText("|cFF4A4A4A" .. getLine(vGet("stade") - 1):GetText())
		
		if getSubLine(vGet("stade") - 1) ~= nil then
			getSubLine(vGet("stade") - 1):SetText("|cFF4A4A4A- Terminé !")
		end 
		
		if getIcon(vGet("stade") - 1) ~= nil then
			getIcon(vGet("stade") - 1):Hide()
		end
	end

	local mission = split(vGet("key"), " ")[vGet("stade")]

	local mission_type = string.sub(mission, 1, 1)
	local setting = string.sub(mission, 2)	

	addMissionLine(getIndication(mission_type, setting), vGet("stade"))

	if mission_type == "3" or mission_type == "4" then
		addMissionSubLine(getSubIndication(mission_type, setting), vGet("stade"))
	elseif mission_type == "5" then
		addIndication("INDICE", getSubIndication(mission_type, setting), vGet("stade"), 2)
	elseif mission_type == "6" then
		addIndication("INDICE", getSubIndication(mission_type, setting), vGet("stade"), 3)
	else
		addIndication("INDICE", getSubIndication(mission_type, setting), vGet("stade"), 1)
	end
end

function clearMissions()
	-- On efface les missions présentes dans le journal
	for i=1, #vGet("key") / 2 do
		if getLine(i) ~= nil then
			getLine(i):Hide()
		end

		if getSubLine(i) ~= nil then
			getSubLine(i):Hide()
		end
	end
end

function displayItemRewards()
	for i=1, getArraySize(vGet("rewards")) do
		local amount = _AClient["rewards"][i]["amount"]
		local itemId = _AClient["rewards"][i]["id"]

		local nList = getArraySize(NuttenhClient.main_frame.itemList)

		NuttenhClient.main_frame.itemList[nList] = CreateFrame("Frame", nil, NuttenhClient.main_frame.reward)
		NuttenhClient.main_frame.itemList[nList]:SetFrameStrata("BACKGROUND")
		NuttenhClient.main_frame.itemList[nList]:SetBackdropBorderColor(255, 0, 0, 1)
		NuttenhClient.main_frame.itemList[nList]:SetPoint("CENTER", ((i - 1) * 42) + 18, 0)
		NuttenhClient.main_frame.itemList[nList]:SetWidth(35) -- Set these to whatever height/width is needed 
		NuttenhClient.main_frame.itemList[nList]:SetHeight(35) -- for your Texture

		local t = NuttenhClient.main_frame.itemList[nList]:CreateTexture(nil,"BACKGROUND")
		t:SetTexture(GetItemIcon(itemId))
		t:SetAllPoints(NuttenhClient.main_frame.itemList[nList])
		NuttenhClient.main_frame.itemList[nList].texture = t

		GetItemInfo(itemId)

		NuttenhClient.main_frame.itemList[nList]:SetScript("OnEnter", function(self)
			local name, link = GetItemInfo(itemId)
		  	GameTooltip:SetOwner(NuttenhClient.main_frame.itemList[nList], "ANCHOR_CURSOR")
		  	GameTooltip:SetHyperlink(link)
		  	GameTooltip:Show()
		end)

		NuttenhClient.main_frame.itemList[nList]:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		NuttenhClient.main_frame.itemList[nList].text = NuttenhClient.main_frame.itemList[nList]:CreateFontString(nil, "OVERLAY")
		NuttenhClient.main_frame.itemList[nList].text:SetPoint("BOTTOMRIGHT", NuttenhClient.main_frame.itemList[nList], 0, 0)
		NuttenhClient.main_frame.itemList[nList].text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
		NuttenhClient.main_frame.itemList[nList].text:SetTextColor(255, 255, 255)
		NuttenhClient.main_frame.itemList[nList].text:SetText(amount)
	end
end

function displayRewards()
	--[[
		1er Cas : 
			Reward Objet = Oui
			Reward Pièce = Oui

		2e Cas :
			Reward Objet = Oui
			Reward Pièce = Non

		3e Cas :
			Reward Objet = Non
			Reward Pièce = Oui

		4e Cas :
			Reward Objet = Non
			Reward Pièce = Non
	]]

	local isRewardItem = false
	local isRewardGold = false

	if vGet("goldReward") == 0 or vGet("goldReward") == nil then
		isRewardGold = false
	else
		isRewardGold = true
	end

	if getArraySize(vGet("rewards")) == 0 or getArraySize(vGet("rewards")) == nil then
		isRewardItem = false
	else
		isRewardItem = true
	end




	if isRewardItem == true and isRewardGold == true then
		if vGet("goldReward") ~= 0 then
			NuttenhClient.main_frame.goldReward.value:SetText(GetCoinTextureString(tonumber(vGet("goldReward") * 10000)))
		end

		displayItemRewards()

		NuttenhClient.main_frame.reward:Show()
		NuttenhClient.main_frame.goldReward:Show()
		NuttenhClient.main_frame.noReward:Hide()
	elseif isRewardItem == true and isRewardGold == false then
		displayItemRewards()

		NuttenhClient.main_frame.reward:Show()
		NuttenhClient.main_frame.goldReward:Hide()
		NuttenhClient.main_frame.noReward:Hide()
	elseif isRewardItem == false and isRewardGold == true then
		if vGet("goldReward") ~= 0 then
			NuttenhClient.main_frame.goldReward:SetPoint("BOTTOMLEFT", 0, 25)
			NuttenhClient.main_frame.goldReward.value:SetText(GetCoinTextureString(tonumber(vGet("goldReward") * 10000)))
		end

		NuttenhClient.main_frame.reward:Hide()
		NuttenhClient.main_frame.goldReward:Show()
		NuttenhClient.main_frame.noReward:Hide()
	elseif isRewardItem == false and isRewardGold == false then
		NuttenhClient.main_frame.reward:Hide()
		NuttenhClient.main_frame.goldReward:Hide()
		NuttenhClient.main_frame.rewardTitle:Hide()
		NuttenhClient.main_frame.noReward:Show()
	end
end

---------------------------------------------------------------------------------------

