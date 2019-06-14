local isMinimized = false

NCloseButton:SetScript("OnClick", function(self, arg1)
	if isMinimized == true then 
		NCloseButton:SetText("-")
		PlaySound("igQuestLogClose", "SFX")
		isMinimized = false
	else
		NCloseButton:SetText("+")
		PlaySound("igQuestLogOpen", "SFX")
		isMinimized = true
	end
end)