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
local colors = {}
colors[1] = "Interface\\COMMON\\Indicator-Red.png"
colors[2] = "Interface\\COMMON\\Indicator-Yellow.png"
colors[3] = "Interface\\COMMON\\Indicator-Gray.png"
colors[4] = "Interface\\COMMON\\Indicator-Green.png"

local selectedColor = colors[1]
table.remove(colors, 1)
table.sort(colors)

local function shuffleTable(t)
    local rand = math.random 
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end

    print(t[1] .. " " .. t[2] .. " " .. t[3])
end

shuffleTable(colors)

-- Affichage des lignes/cases
for a = 0, 3 do
    NuttenhClient.stupid_race.itemList[a] = {}

    for i = 0, 31 do
        local texture = ""

        if i == 0 then
            if a == 0 then
                texture = selectedColor
            else
                texture = colors[a]
            end
        else
            texture = "Interface\\PaperDoll\\UI-Backpack-EmptySlot"
        end

        NuttenhClient.stupid_race.itemList[a][i] = {}
        NuttenhClient.stupid_race.itemList[a][i] = CreateFrame("Frame", nil, NuttenhClient.stupid_race.frame)
        NuttenhClient.stupid_race.itemList[a][i]:SetFrameStrata("BACKGROUND")
        NuttenhClient.stupid_race.itemList[a][i]:SetBackdropBorderColor(255, 0, 0, 1)
        NuttenhClient.stupid_race.itemList[a][i]:SetPoint("TOPLEFT", i * 25 + 30, a * -35 - 35)
        NuttenhClient.stupid_race.itemList[a][i]:SetWidth(25) -- Set these to whatever height/width is needed 
        NuttenhClient.stupid_race.itemList[a][i]:SetHeight(25) -- for your Texture

        local t = NuttenhClient.stupid_race.itemList[a][i]:CreateTexture(nil,"BACKGROUND")
        t:SetTexture(texture)
        t:SetAllPoints(NuttenhClient.stupid_race.itemList[a][i])
        NuttenhClient.stupid_race.itemList[a][i].texture = t
    end
end