NuttenhClient = {}
NuttenhClient.addonName = "Client"



local t = CreateFrame("Frame")
t:RegisterEvent("UNIT_TARGET")
t:SetScript("OnEvent", function(pUnit, ...)
	print()
end)

