NuttenhClient = {}
NuttenhClient.addonName = "Event-Client"

-- Main frame
NuttenhClient.main_frame = CreateFrame("Frame", nil, UIParent)
NuttenhClient.main_frame:SetFrameStrata("BACKGROUND") -- Définit le z-index de la frame sur le niveau le plus bas (BACKGROUND)
NuttenhClient.main_frame:SetMovable(true) -- Permet le déplacement de la fenêtre
NuttenhClient.main_frame:EnableMouse(true)
NuttenhClient.main_frame:RegisterForDrag("LeftButton") -- Définit le clic gauche comme le bouton à utiliser pour déplacer la fenêtre
NuttenhClient.main_frame:SetScript("OnDragStart", NuttenhClient.main_frame.StartMoving)
NuttenhClient.main_frame:SetScript("OnDragStop", NuttenhClient.main_frame.StopMovingOrSizing)
NuttenhClient.main_frame:SetWidth(300)
NuttenhClient.main_frame:SetHeight(450)

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

NuttenhClient.main_frame:Show()

-- Close button
local close_button = CreateFrame("Button", "CloseButton", NuttenhClient.main_frame, "GameMenuButtonTemplate")
close_button:SetPoint("TOPRIGHT", 0, 0)
close_button:SetFrameStrata("HIGH")
close_button:SetFrameLevel(4)
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
		NuttenhClient.main_frame.reward:Hide()
		isMinimized = true
	else
		NuttenhClient.main_frame:SetHeight(450)
		NuttenhClient.main_frame.mission_list:Show()
		NuttenhClient.main_frame.reward:Show()
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

function addLine(text, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetPoint("TOPLEFT", 0, 0 - (lineNumber * 30))
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetTextColor(0, 0, 0, 1)
end

function getLine(lineNumber)
	return NuttenhClient.main_frame.mission_list.content[lineNumber]
end

function getLines()
	return NuttenhClient.main_frame.mission_list.content
end

function addDescLine(id)
	local line = 0
	local readed_key = readKey(_Client["key"], id)
	if readed_key["mission_type"] == "1" then
		line = line + 1
		loadLists()
		addLine(NPC_LIST[readed_key["setting"]]["indication"], id)
	elseif readed_key["mission_type"] == "2" then
		line = line + 1
		loadLists()
		addLine("Vous devez trouver " .. LOCATIONS_LIST[readed_key["setting"]]["indication"], id)
		-- addSubLine("Localisation : " .. LOCATIONS_LIST[readed_key["setting"]]["zoneText"][GetLocale()] .. ", " .. LOCATIONS_LIST[readed_key["setting"]]["subZoneText"][GetLocale()], id)
	elseif readed_key["mission_type"] == "3" then
		line = line + 1
		loadLists()
		addLine(ITEMS_LIST[readed_key["setting"]]["indication"], id)
		-- addSubLine("", id)
	elseif readed_key["mission_type"] == "4" then
		line = line + 1
		addLine(KILL_LIST[readed_key["setting"]]["indication"], id)
		-- addSubLine("", id)
	elseif readed_key["mission_type"] == "5" then 
		line = line + 1
		loadLists()
		addLine(ANSWER_LIST[readed_key["setting"]]["indication"], id)
	end
end

function displayRewards(rewards)
	for i=0, getArraySize(rewards) - 1 do
		local itemId = nil
		
		if i == 0 then
			itemId = _Client["rewards"][0]["id"]
		else
			itemId = _Client["rewards"][i]["id"]
		end
		
		local x = ((i) * 42) + 18

		local itemFrame = CreateFrame("Frame", nil, NuttenhClient.main_frame.reward)
		itemFrame:SetFrameStrata("BACKGROUND")
		itemFrame:SetBackdropBorderColor(255, 0, 0, 1)
		itemFrame:SetPoint("CENTER", x, 0)
		itemFrame:SetWidth(35) -- Set these to whatever height/width is needed 
		itemFrame:SetHeight(35) -- for your Texture

		local t = itemFrame:CreateTexture(nil,"BACKGROUND")
		t:SetTexture(GetItemIcon(itemId))
		t:SetAllPoints(itemFrame)
		itemFrame.texture = t

		itemFrame:SetScript("OnEnter", function(self)
			local name, link = GetItemInfo(itemId)
		  	GameTooltip:SetOwner(itemFrame, "ANCHOR_CURSOR")
		  	GameTooltip:SetHyperlink(link)
		  	GameTooltip:Show()
		end)

		itemFrame:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)

		itemFrame.text = itemFrame:CreateFontString(nil, "OVERLAY")
		itemFrame.text:SetPoint("BOTTOMRIGHT", itemFrame, 0, 0)
		itemFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
		itemFrame.text:SetTextColor(255, 255, 255)
		itemFrame.text:SetText("5")
	end
end