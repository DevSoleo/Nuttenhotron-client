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
NuttenhClient.main_frame.close_button:SetHeight(25)
NuttenhClient.main_frame.close_button:SetWidth(25)

NuttenhClient.main_frame.close_button.fontString = NuttenhClient.main_frame.close_button:CreateFontString(nil, "ARTWORK")
NuttenhClient.main_frame.close_button.fontString:SetAllPoints()
NuttenhClient.main_frame.close_button.fontString:SetFont("Fonts\\FRIZQT__.TTF", 20)
NuttenhClient.main_frame.close_button.fontString:SetTextColor(255, 255, 0, 1)
NuttenhClient.main_frame.close_button.fontString:SetShadowOffset(1, -1)
NuttenhClient.main_frame.close_button.fontString:SetText("-")

local isMinimized = false

function NuttenhClient.main_frame:toggleSize()
	if isMinimized == false then
		NuttenhClient.main_frame:SetHeight(60)
		-- NuttenhClient.main_frame.mission_list:Hide()

		-- NuttenhClient.main_frame.noReward:Hide()
		-- NuttenhClient.main_frame.reward:Hide()
			
		NuttenhClient.main_frame.close_button.fontString:SetText("+")
		NuttenhClient.main_frame.close_button.fontString:SetFont("Fonts\\FRIZQT__.TTF", 16)

		PlaySound("igQuestLogOpen", "SFX")

		isMinimized = true
	else
		NuttenhClient.main_frame:SetHeight(450)
		-- NuttenhClient.main_frame.mission_list:Show()

		--[[if getArraySize(NuttenhClient.main_frame.itemList) == 0 then
			NuttenhClient.main_frame.noReward:Show()
		else
			NuttenhClient.main_frame.reward:Show()
		end]]

		NuttenhClient.main_frame.close_button.fontString:SetText("-")

		PlaySound("igQuestLogClose", "SFX")

		isMinimized = false
	end
end

NuttenhClient.main_frame.close_button:SetScript("OnClick", function(self, arg1)
	NuttenhClient.main_frame:toggleSize()
end)

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
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetMinMaxValues(1, 200) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.scrollStep = 200 / 100
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetValueStep(NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.scrollStep) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetValue(0) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetWidth(16) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetFrameLevel(1)
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:SetScript("OnValueChanged", function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end)

NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.background = NuttenhClient.main_frame.mission_list.scrollframe.scrollbar:CreateTexture(nil, "BACKGROUND") 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.background:SetAllPoints(scrollbar) 
NuttenhClient.main_frame.mission_list.scrollframe.scrollbar.background:SetTexture(0, 0, 0, 0) 

--content frame 
NuttenhClient.main_frame.mission_list.content = CreateFrame("Frame", nil, NuttenhClient.main_frame.mission_list.scrollframe) 
NuttenhClient.main_frame.mission_list.content:SetSize(250, 250) 

NuttenhClient.main_frame.mission_list.scrollframe:SetScrollChild(NuttenhClient.main_frame.mission_list.content)

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

if getArraySize(vGet("rewards")) == 0 or getArraySize(vGet("rewards")) == nil then
	NuttenhClient.main_frame.noReward:Show()
	NuttenhClient.main_frame.reward:Hide()
else
	NuttenhClient.main_frame.noReward:Hide()
	NuttenhClient.main_frame.reward:Show()
end

function addMissionLine(text, lineNumber)
	NuttenhClient.main_frame.mission_list.content[lineNumber] = NuttenhClient.main_frame.mission_list.content:CreateFontString(nil, "ARTWORK")
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetFont("Fonts\\ARIALN.ttf", 15)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetPoint("TOPLEFT", 0, 0 - ((lineNumber - 1) * 35))
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetText("- " .. text)
	NuttenhClient.main_frame.mission_list.content[lineNumber]:SetTextColor(0, 0, 0, 1)
end
