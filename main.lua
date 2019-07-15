NuttenhClient = {}
NuttenhClient.addonName = "Event-Client"

NuttenhClient.stupid_race = {}

-- Création de la fenêtre principale
NuttenhClient.stupid_race.frame = CreateFrame("Frame", nil, UIParent)
NuttenhClient.stupid_race.frame:SetFrameStrata("BACKGROUND")
NuttenhClient.stupid_race.frame:SetWidth(850)
NuttenhClient.stupid_race.frame:SetHeight(300)

NuttenhClient.stupid_race.frame:SetBackdrop({
    bgFile="Interface/Tooltips/UI-Tooltip-Background", 
    edgeFile="Interface/Tooltips/UI-Tooltip-Border",
    tile=false,
    tileSize=64, 
    edgeSize=14, 
    insets={
        left=4,
        right=4,
        top=4,
        bottom=4
    }
})

NuttenhClient.stupid_race.frame:SetBackdropColor(0, 0, 0)
NuttenhClient.stupid_race.frame:SetPoint("CENTER", 0, 50)

NuttenhClient.stupid_race.itemList = {}

--[[
    Red = 0
    Yellow = 1
    Gray = 2
    Green = 3
]]
NuttenhClient.stupid_race.colors = {}
NuttenhClient.stupid_race.colors[1] = "Interface\\COMMON\\Indicator-Red.png"
NuttenhClient.stupid_race.colors[2] = "Interface\\COMMON\\Indicator-Yellow.png"
NuttenhClient.stupid_race.colors[3] = "Interface\\COMMON\\Indicator-Gray.png"
NuttenhClient.stupid_race.colors[4] = "Interface\\COMMON\\Indicator-Green.png"

local selectedColorId = 4
local selectedColor = NuttenhClient.stupid_race.colors[selectedColorId]

table.remove(NuttenhClient.stupid_race.colors, selectedColorId)
table.sort(NuttenhClient.stupid_race.colors)

shuffleTable(NuttenhClient.stupid_race.colors)

-- Affichage des colonnes
for a = 0, 3 do
    NuttenhClient.stupid_race.itemList[a] = {}

    -- Affichage des lignes/cases
    for i = 0, 31 do
        local tooltipText = ""
        local texture = ""

        -- On créée l'icône (cercle de couleur, fond d'item)
        NuttenhClient.stupid_race.itemList[a][i] = {}
        NuttenhClient.stupid_race.itemList[a][i] = CreateFrame("Frame", nil, NuttenhClient.stupid_race.frame)

        NuttenhClient.stupid_race.itemList[a][i]:SetFrameStrata("BACKGROUND")
        NuttenhClient.stupid_race.itemList[a][i]:SetBackdropBorderColor(255, 0, 0, 1)
        NuttenhClient.stupid_race.itemList[a][i]:SetPoint("TOPLEFT", i * 25 + 30, a * -35 - 35)
        NuttenhClient.stupid_race.itemList[a][i]:SetWidth(25) -- Set these to whatever height/width is needed 
        NuttenhClient.stupid_race.itemList[a][i]:SetHeight(25) -- for your Texture

        if i == 0 then
            if a == 0 then
                texture = selectedColor
                tooltipText = "Joueur - " .. UnitName("player")
                NuttenhClient.stupid_race.itemList[a][i]:SetFrameLevel(5)
            else
                texture = NuttenhClient.stupid_race.colors[a]
                tooltipText = "Joueur - " .. a + 1
                NuttenhClient.stupid_race.itemList[a][i]:SetFrameLevel(5)
            end
        else
            texture = "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
        end

        NuttenhClient.stupid_race.itemList[a][i]:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(NuttenhClient.stupid_race.itemList[a][i], "ANCHOR_CURSOR")
            GameTooltip:SetText(tooltipText)
            GameTooltip:Show()
        end)

        NuttenhClient.stupid_race.itemList[a][i]:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        local t = NuttenhClient.stupid_race.itemList[a][i]:CreateTexture(nil,"BACKGROUND")
        t:SetTexture(texture)
        t:SetAllPoints(NuttenhClient.stupid_race.itemList[a][i])
        NuttenhClient.stupid_race.itemList[a][i].texture = t
    end
end

NuttenhClient.stupid_race.move_button = CreateFrame("Button", "aze", NuttenhClient.stupid_race.frame, "GameMenuButtonTemplate")
NuttenhClient.stupid_race.move_button:SetPoint("BOTTOM", 0, 50)
NuttenhClient.stupid_race.move_button:SetFrameLevel(5)
NuttenhClient.stupid_race.move_button:SetHeight(30)
NuttenhClient.stupid_race.move_button:SetWidth(100)
NuttenhClient.stupid_race.move_button:SetText("Valider")

NuttenhClient.stupid_race.move_button:SetScript("OnClick", function(self)
    local row = 15

    for line=0, row do
        NuttenhClient.stupid_race.itemList[2][0]:SetPoint("TOPLEFT", row * 25 + 30, line * -35 - 35)
    end
end)

