NuttenhClient = {}
NuttenhClient.addonName = "Event-Client"


--[[local isRight = false
local isLeft = false

local function test()
    if isRight == true and isLeft == true then
        print("T CHOV !")
    end
end

local function rightClickStart(...)
    isRight = true;
    test()
end

local function leftClickStart(...)
    isLeft = true;
    test()
end

local function rightClickStop(...)
    isRight = false;
end

local function leftClickStop(...)
    isLeft = false;
end


hooksecurefunc("CameraOrSelectOrMoveStart"  , rightClickStart)
hooksecurefunc("CameraOrSelectOrMoveStop"   , rightClickStop)

hooksecurefunc("TurnOrActionStart"  , leftClickStart)
hooksecurefunc("TurnOrActionStop"  , leftClickStop)

hooksecurefunc("ToggleAutoRun", function()
    print("apizjaeozhbehjaek")
end)
]]