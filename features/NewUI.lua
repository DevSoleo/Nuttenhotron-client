NuttenhClient = {}
NuttenhClient.addonName = "Event-Client"

-- On créer la fenêtre principale
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

NuttenhClient.main_frame:SetBackdrop({
	bgFile="Interface\\Addons\\wow-event-addon-client\\textures\\UI-Background", -- Interface/Tooltips/UI-Tooltip-Background
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

NuttenhClient.main_frame:SetPoint("TOP", 20, -20)

NuttenhClient.main_frame:Hide()

-- Close button
local close_button = CreateFrame("Button", "CloseButton1", NuttenhClient.main_frame, "GameMenuButtonTemplate")
close_button:SetPoint("TOPRIGHT", 0, 0)
close_button:SetFrameLevel(1)
close_button:SetHeight(27)
close_button:SetWidth(27)

local fontString = close_button:CreateFontString(nil, 'ARTWORK')
fontString:SetAllPoints()
fontString:SetFont("Fonts\\FRIZQT__.TTF", 20)
fontString:SetTextColor(255, 255, 0, 1)
fontString:SetShadowOffset(1, -1)
fontString:SetText("-")

close_button.fontString = fontString

isMinimized = false

function toggleFrameSize()
	if isMinimized == false then
		NuttenhClient.main_frame:SetHeight(60)
		NuttenhClient.main_frame.mission_list:Hide()

		NuttenhClient.main_frame.noReward:Hide()
		NuttenhClient.main_frame.reward:Hide()
	
		isMinimized = true
	else
		NuttenhClient.main_frame:SetHeight(450)
		NuttenhClient.main_frame.mission_list:Show()

		if getArraySize(NuttenhClient.main_frame.itemList) == 0 then
			NuttenhClient.main_frame.noReward:Show()
		else
			NuttenhClient.main_frame.reward:Show()
		end

		isMinimized = false
	end
end

close_button:SetScript("OnClick", function(self, arg1)
	if isMinimized == true then 
		fontString:SetText("-")
		PlaySound("igQuestLogClose", "SFX");
	else
		fontString:SetText("+")
		fontString:SetFont("Fonts\\FRIZQT__.TTF", 16)
		PlaySound("igQuestLogOpen", "SFX");
	end

	toggleFrameSize()
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

NuttenhClient.main_frame.statusbar:SetBackdrop({
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
NuttenhClient.main_frame.mission_list = CreateFrame("Frame", "MissionList", NuttenhClient.main_frame)
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

local bg = NuttenhClient.main_frame.mission_list:CreateTexture(nil, "BACKGROUND") 
bg:SetAllPoints(NuttenhClient.main_frame.mission_list) 
bg:SetTexture(0, 0, 0, 0.1) 

-- Mission list scroll bar
local scrollframe = CreateFrame("ScrollFrame", nil, NuttenhClient.main_frame.mission_list) 
scrollframe:SetPoint("TOPLEFT", 10, -10) 
scrollframe:SetPoint("BOTTOMRIGHT", -10, 10)

local texture = scrollframe:CreateTexture() 
texture:SetAllPoints() 
-- texture:SetTexture(0.5, 0.5, 0.5, 1) 
NuttenhClient.main_frame.mission_list.scrollframe = scrollframe 

--scrollbar 
local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", NuttenhClient.main_frame.mission_list, "TOPRIGHT", -20, -18) 
scrollbar:SetPoint("BOTTOMLEFT", NuttenhClient.main_frame.mission_list, "BOTTOMRIGHT", -20, 18) 
scrollbar:SetMinMaxValues(1, 200) 
scrollbar.scrollStep = 200 / 100
scrollbar:SetValueStep(scrollbar.scrollStep) 
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar:SetFrameLevel(1)
scrollbar:SetScript("OnValueChanged", function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end)


local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg:SetAllPoints(scrollbar) 
scrollbg:SetTexture(0, 0, 0, 0) 
NuttenhClient.main_frame.mission_list.scrollbar = scrollbar 

--content frame 
NuttenhClient.main_frame.mission_list.content = CreateFrame("Frame", nil, scrollframe) 
NuttenhClient.main_frame.mission_list.content:SetSize(250, 250) 

scrollframe:SetScrollChild(NuttenhClient.main_frame.mission_list.content)

-- Rewards
NuttenhClient.main_frame.reward = CreateFrame("Frame", nil, NuttenhClient.main_frame)
NuttenhClient.main_frame.reward:SetPoint("BOTTOMLEFT", 0, 60)
NuttenhClient.main_frame.reward:SetHeight(27)
NuttenhClient.main_frame.reward:SetWidth(27)

NuttenhClient.main_frame.reward.value = NuttenhClient.main_frame.reward:CreateFontString(nil, "OVERLAY")
NuttenhClient.main_frame.reward.value:SetPoint("CENTER", NuttenhClient.main_frame.reward, "TOP", 100, 20)
NuttenhClient.main_frame.reward.value:SetFont("Fonts\\MORPHEUS.ttf", 18)
NuttenhClient.main_frame.reward.value:SetTextColor(0, 0, 0, 0.8)
NuttenhClient.main_frame.reward.value:SetText("Le vainqueur remportera :")

NuttenhClient.main_frame.noReward = NuttenhClient.main_frame:CreateFontString(nil, "ARTWORK")
NuttenhClient.main_frame.noReward:SetFont("Fonts\\ARIALN.ttf", 17)
NuttenhClient.main_frame.noReward:SetPoint("BOTTOM", 0, 55)
NuttenhClient.main_frame.noReward:SetText("Les officiers n'ont déterminé \n aucune récompense pour cet évènement")
NuttenhClient.main_frame.noReward:SetTextColor(0, 0, 0, 1)

function addLine(text, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetPoint("TOPLEFT", 0, 0 - ((lineNumber - 1) * 35))
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetTextColor(0, 0, 0, 1)
end

function addSubLine(text, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetPoint("TOPLEFT", 15, 0 - ((lineNumber - 1) * 35 + 15))
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)
end

-- Cette fonction sert à afficher un tooltip au passage de la souris sur la sub line
function addSubLineT(text, tooltip, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetPoint("TOPLEFT", 15,  0 - ((lineNumber - 1) * 35 + 15))
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)

	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon = CreateFrame("Frame", nil, NuttenhClient.main_frame.mission_list.content)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetFrameStrata("BACKGROUND")
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetBackdropBorderColor(255, 0, 0, 1)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetPoint("TOPLEFT", 75, 0 - ((lineNumber - 1) * 35 + 15))
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetWidth(15) -- Set these to whatever height/width is needed 
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetHeight(15) -- for your Texture

	local t = NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:CreateTexture(nil,"BACKGROUND")
	t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	t:SetAllPoints(NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon)
	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon.texture = t


	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetScript("OnEnter", function(self)
	  	GameTooltip:SetOwner(NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon, "ANCHOR_CURSOR")
	  	GameTooltip:SetText(tooltip)
	  	GameTooltip:Show()
	end)

	NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
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

function getIndication(lineNumber)
	if NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon ~= nil then
		return NuttenhClient.main_frame.mission_list.content[lineNumber]["sub"].icon
	else
		return nil
	end
end
function addDescLine(id)
	local line = 0
	local readed_key = readKey(_Client["key"], id)
	if readed_key["mission_type"] == "1" then
		line = line + 1
		loadLists()
		addLine("Parlez à : " .. NPC_LIST[readed_key["setting"]]["name"][GetLocale()], id)
		addSubLineT("INDICE :", NPC_LIST[readed_key["setting"]]["indication"], id)
		--addSubLine(NPC_LIST[readed_key["setting"]]["indication"], id)
	elseif readed_key["mission_type"] == "2" then
		line = line + 1
		loadLists()
		addLine("Trouvez : " .. LOCATIONS_LIST[readed_key["setting"]]["zoneText"][GetLocale()], id)
		addSubLineT("INDICE :", LOCATIONS_LIST[readed_key["setting"]]["indication"], id)
		-- addSubLine("Localisation : " .. LOCATIONS_LIST[readed_key["setting"]]["zoneText"][GetLocale()] .. ", " .. LOCATIONS_LIST[readed_key["setting"]]["subZoneText"][GetLocale()], id)
	elseif readed_key["mission_type"] == "3" then
		line = line + 1
		loadLists()
		addLine("Possédez : ".. ITEMS_LIST[readed_key["setting"]]["indication"], id)
		addSubLine("Compteur : 0/" .. ITEMS_LIST[readed_key["setting"]]["amount"], id)
		-- addSubLine("", id)
	elseif readed_key["mission_type"] == "4" then
		line = line + 1
		addLine("Tuez : " .. KILL_LIST[readed_key["setting"]]["name"][GetLocale()], id)

		local kills = 0

		if vGet("kills") ~= nil and vGet("kills") ~= 0 then
			kills = vGet("kills")
		end

		addSubLine("Compteur : " .. kills .. "/" .. KILL_LIST[readed_key["setting"]]["amount"], id)
	elseif readed_key["mission_type"] == "5" then 
		line = line + 1
		loadLists()
		addLine(ANSWER_LIST[readed_key["setting"]]["indication"], id)
		addSubLine("", id)
	end
end

NuttenhClient.main_frame.itemList = {}

function displayRewards(rewards)
	if rewards ~= nil then
		if getArraySize(rewards) ~= 0 then
			NuttenhClient.main_frame.reward.value:Show()
			NuttenhClient.main_frame.noReward:Hide()

			for i=0, getArraySize(rewards) - 1 do
				local amount = 0
				local itemId = nil
				
				if i == 0 then
					itemId = _Client["rewards"][0]["id"]
				else
					itemId = _Client["rewards"][i]["id"]
				end

				if i == 0 then
					amount = _Client["rewards"][0]["amount"]
				else
					amount = _Client["rewards"][i]["amount"]
				end
				
				local x = ((i) * 42) + 18
				local nList = getArraySize(NuttenhClient.main_frame.itemList)

				NuttenhClient.main_frame.itemList[nList] = CreateFrame("Frame", nil, NuttenhClient.main_frame.reward)
				NuttenhClient.main_frame.itemList[nList]:SetFrameStrata("BACKGROUND")
				NuttenhClient.main_frame.itemList[nList]:SetBackdropBorderColor(255, 0, 0, 1)
				NuttenhClient.main_frame.itemList[nList]:SetPoint("CENTER", x, 0)
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
		else
			NuttenhClient.main_frame.reward.value:Hide()
			NuttenhClient.main_frame.noReward:Show()
		end
	end
end