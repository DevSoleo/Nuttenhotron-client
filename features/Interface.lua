NuttenhClient.main_frame = CreateFrame("Frame", nil, UIParent)
NuttenhClient.main_frame:SetFrameStrata("BACKGROUND") -- Définit le z-index de la frame sur le niveau le plus bas (BACKGROUND)
NuttenhClient.main_frame:SetMovable(true) -- Permet le déplacement de la fenêtre
NuttenhClient.main_frame:EnableMouse(true)
NuttenhClient.main_frame:RegisterForDrag("LeftButton") -- Définit le clic gauche comme le bouton à utiliser pour déplacer la fenêtre
NuttenhClient.main_frame:SetScript("OnDragStart", frame.StartMoving)
NuttenhClient.main_frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
NuttenhClient.main_frame:SetWidth(300)
NuttenhClient.main_frame:SetHeight(400)

NuttenhClient.main_frame:SetBackdrop({
	bgFile="Interface\\Addons\\wow-event-addon-client\\textures\\UI-Background", -- Interface/Tooltips/UI-Tooltip-Background
	edgeFile="Interface/Tooltips/UI-Tooltip-Border", 
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

NuttenhClient.main_frame:SetPoint("TOP", 0, -20)
NuttenhClient.main_frame:Hide()

NuttenhClient.mission_line_list = CreateFrame("Frame", "MissionLineList", NuttenhClient.main_frame)
NuttenhClient.mission_line_list:SetWidth(100)
NuttenhClient.mission_line_list:SetHeight(15)
NuttenhClient.mission_line_list:SetPoint("TOPLEFT", 0, 0)

NuttenhClient.missions_lines_array = {}

function addLine(text, lineNumber)
	NuttenhClient.missions_lines_array[lineNumber] = NuttenhClient.mission_line_list:CreateFontString(nil, "ARTWORK")
	NuttenhClient.missions_lines_array[lineNumber]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.missions_lines_array[lineNumber]:SetPoint("LEFT", 20, -60 - (lineNumber * 35))
	NuttenhClient.missions_lines_array[lineNumber]:SetText("- " .. tostring(text))
	NuttenhClient.missions_lines_array[lineNumber]:SetTextColor(0, 0, 0, 1)
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
		addLine("Vous devez trouver " .. LOCATIONS_LIST[readed_key["setting"]]["indication"], id)
		addSubLine("Localisation : " .. LOCATIONS_LIST[readed_key["setting"]]["zoneText"][GetLocale()] .. ", " .. LOCATIONS_LIST[readed_key["setting"]]["subZoneText"][GetLocale()], id)
	elseif readed_key["mission_type"] == "3" then
		line = line + 1
		loadLists()
		addLine(ITEMS_LIST[readed_key["setting"]]["indication"], id)
		addSubLine("", id)
	elseif readed_key["mission_type"] == "4" then
		line = line + 1
		addLine(KILL_LIST[readed_key["setting"]]["indication"], id)
	elseif readed_key["mission_type"] == "5" then 
		line = line + 1
		loadLists()
		addLine(ANSWER_LIST[readed_key["setting"]]["indication"], id)
	end
end

function addSubLine(text, lineNumber)
	NuttenhClient.missions_lines_array[lineNumber]["sub"] = NuttenhClient.mission_line_list:CreateFontString(NuttenhClient.missions_lines_array[lineNumber], "ARTWORK")
	NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetPoint("LEFT", 30, 0 - 60 - (lineNumber * 35) - 17)
	NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetText("- " .. tostring(text))
	NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetTextColor(0, 0, 0, 1)
	NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetWidth(200)
	NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetHeight(15)

	if lineNumber == 3 then
		NuttenhClient.missions_lines_array[lineNumber]["sub"]:SetPoint("LEFT", -16, 0 - 60 - (lineNumber * 35) - 17)
	end
end

NuttenhClient.reward_frame = CreateFrame("Frame", nil, NuttenhClient.main_frame)
NuttenhClient.reward_frame:SetPoint("BOTTOMLEFT", 0, 60)
NuttenhClient.reward_frame:SetHeight(27)
NuttenhClient.reward_frame:SetWidth(27)

isMinimized = false
function toggleFrameSize()
	if isMinimized == false then
		NuttenhClient.mission_line_list:Hide()
		NuttenhClient.main_frame:SetHeight(60)
		NuttenhClient.reward_frame:Hide()
		NuttenhClient.reward_frame.value:Hide()
		isMinimized = true
	else
		NuttenhClient.mission_line_list:Show()
		NuttenhClient.main_frame:SetHeight(400)
		NuttenhClient.reward_frame:Show()
		NuttenhClient.reward_frame.value:Show()
		isMinimized = false
	end
end

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

statusbar = CreateFrame("StatusBar", nil, NuttenhClient.main_frame)
statusbar:SetPoint("TOP", NuttenhClient.main_frame, "TOP", 0, -30)
statusbar:SetWidth(200)
statusbar:SetHeight(16)
statusbar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar:SetStatusBarColor(0, 0.65, 0)
statusbar:SetMinMaxValues(0, 100)
statusbar:SetValue(0)

statusbar.text = statusbar:CreateFontString(nil, "ARTWORK")
statusbar.text:SetFont("Fonts\\ARIALN.ttf", 15)
statusbar.text:SetPoint("TOP", 0, 20)
statusbar.text:SetText("Progression :")
statusbar.text:SetTextColor(0, 0, 0, 1)

statusbar.bg = statusbar:CreateTexture(nil, "BACKGROUND")
statusbar.bg:SetTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
statusbar.bg:SetAllPoints(true)
statusbar.bg:SetVertexColor(0, 0, 0)

statusbar.value = statusbar:CreateFontString(nil, "OVERLAY")
statusbar.value:SetPoint("CENTER", statusbar, "TOP", 0, -8)
statusbar.value:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
statusbar.value:SetTextColor(255, 255, 0)
statusbar.value:SetText("0%")

NuttenhClient.reward_frame.value = NuttenhClient.reward_frame:CreateFontString(nil, "OVERLAY")
NuttenhClient.reward_frame.value:SetPoint("CENTER", NuttenhClient.reward_frame, "TOP", 100, 20)
NuttenhClient.reward_frame.value:SetFont("Fonts\\MORPHEUS.ttf", 18)
NuttenhClient.reward_frame.value:SetTextColor(0, 0, 0, 0.8)
NuttenhClient.reward_frame.value:SetText("Le vainqueur remportera :")

function displayRewards(rewards)
	for i=0, getArraySize(rewards) - 1 do

		local itemId = nil
		
		if i == 0 then
			itemId = _Client["rewards"][0]["id"]
		else
			itemId = _Client["rewards"][i]["id"]
		end
		
		local x = ((i) * 42) + 18

		local itemFrame = CreateFrame("Frame", nil, NuttenhClient.reward_frame)
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