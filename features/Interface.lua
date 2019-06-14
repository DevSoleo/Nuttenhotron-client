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