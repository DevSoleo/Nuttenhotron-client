NuttenhClient.memo = {}

-- Création de la fenêtre principale
NuttenhClient.memo.memo_frame = CreateFrame("Frame", nil, UIParent)
NuttenhClient.memo.memo_frame:SetFrameStrata("BACKGROUND")
NuttenhClient.memo.memo_frame:SetWidth(250)
NuttenhClient.memo.memo_frame:SetHeight(250)

NuttenhClient.memo.memo_frame:SetBackdrop({
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

NuttenhClient.memo.memo_frame:SetBackdropColor(0, 0, 0)
NuttenhClient.memo.memo_frame:SetPoint("CENTER", 0, 20)

NuttenhClient.memo.memo_frame:Hide()

NuttenhClient.memo.title = NuttenhClient.memo.memo_frame:CreateFontString(nil, "ARTWORK")
NuttenhClient.memo.title:SetFont("Fonts\\FRIZQT__.TTF", 14)
NuttenhClient.memo.title:SetPoint("TOP", 0, -30)
NuttenhClient.memo.title:SetText("Résolvez le mémo suivant :")
NuttenhClient.memo.title:SetTextColor(255, 255, 255, 1)

NuttenhClient.memo.itemsFrames = {}
-- NuttenhClient.memo.openedFrames : stocke le nombre de frames d'items actuellement ouvertes
NuttenhClient.memo.openedFrames = 0

-- NuttenhClient.memo.totalMove : stocke le nombre TOTAL de tours
NuttenhClient.memo.totalMoves = 0

-- NuttenhClient.memo.points : stocke le nombre de points gagnés par le joueur
NuttenhClient.memo.points = 0

NuttenhClient.memo.move = nil

NuttenhClient.memo.moveOne = {}
NuttenhClient.memo.moveTwo = {}

NuttenhClient.memo.moveOne.id = nil
NuttenhClient.memo.moveTwo.id = nil

NuttenhClient.memo.moveOne.pos = nil
NuttenhClient.memo.moveTwo.pos = nil

NuttenhClient.memo.points = 0
NuttenhClient.memo.boxes = 12

NuttenhClient.memo.itemPositions = {}

NuttenhClient.memo.inCooldown = false

function addIcon(itemId, x, y)
	local i = getArraySize(NuttenhClient.memo.itemsFrames)

	NuttenhClient.memo.itemsFrames[i] = CreateFrame("Frame", nil, NuttenhClient.memo.memo_frame)
	NuttenhClient.memo.itemsFrames[i]:SetSize(35, 35)
	NuttenhClient.memo.itemsFrames[i]:SetPoint("BOTTOM", x, y)

	NuttenhClient.memo.itemsFrames[i]["itemId"] = itemId

	NuttenhClient.memo.itemsFrames[i]["texture"] = NuttenhClient.memo.itemsFrames[i]:CreateTexture()
	NuttenhClient.memo.itemsFrames[i]["texture"]:SetAllPoints()
	NuttenhClient.memo.itemsFrames[i]["texture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	-- NuttenhClient.memo.itemsFrames[i]["texture"]:SetTexture(GetItemIcon(itemId)) -- A RETIRER

	NuttenhClient.memo.itemsFrames[i]["cooldown"] = CreateFrame("Cooldown", "Memo_Cooldown_" .. i, NuttenhClient.memo.itemsFrames[i], "CooldownFrameTemplate")
	NuttenhClient.memo.itemsFrames[i]["cooldown"]:SetAllPoints()

	NuttenhClient.memo.itemsFrames[i]["cooldown"]:SetCooldown(GetTime(), 0.1)

	NuttenhClient.memo.itemsFrames[i]["button"] = CreateFrame("Button", nil, NuttenhClient.memo.itemsFrames[i])
	NuttenhClient.memo.itemsFrames[i]["button"]:SetFrameStrata("BACKGROUND")
	NuttenhClient.memo.itemsFrames[i]["button"]:SetBackdropBorderColor(255, 0, 0, 1)
	NuttenhClient.memo.itemsFrames[i]["button"]:SetAllPoints()

	NuttenhClient.memo.itemsFrames[i]["button"]:SetScript("OnClick", function(self)
		if NuttenhClient.memo.inCooldown == false and i ~= NuttenhClient.memo.moveOne.pos then
			local cooldown = 2

			-- print("ID : " .. i)

			NuttenhClient.memo.totalMoves = NuttenhClient.memo.totalMoves + 1

			NuttenhClient.memo.openedFrames = NuttenhClient.memo.openedFrames + 1

			if NuttenhClient.memo.totalMoves % 2 == 0 then
				-- Second tour
				NuttenhClient.memo.moveTwo.id = NuttenhClient.memo.itemsFrames[i]["itemId"]
				NuttenhClient.memo.moveTwo.pos = i

				if NuttenhClient.memo.moveOne.id == NuttenhClient.memo.moveTwo.id then
					NuttenhClient.memo.moveOne.id = nil
					NuttenhClient.memo.moveTwo.id = nil

					NuttenhClient.memo.itemsFrames[NuttenhClient.memo.moveOne.pos]:Hide()
					NuttenhClient.memo.itemsFrames[NuttenhClient.memo.moveTwo.pos]:Hide()

					NuttenhClient.memo.points = NuttenhClient.memo.points + 1

					if NuttenhClient.memo.points >= NuttenhClient.memo.boxes / 2 then 
						-- Victoire
						NuttenhClient.memo.memo_frame:Hide()
				  		NuttenhClient.main_frame.statusbar:SetValue(vGet("stade") * 100 / getArraySize(split(vGet("key"), " ")))
						NuttenhClient.main_frame.statusbar.value:SetText(tostring(round(vGet("stade") * 100 / getArraySize(split(vGet("key"), " ")))) .. "%")
						startMission(vGet("key"), vGet("stade") + 1)
					end
				else
					NuttenhClient.memo.itemsFrames[NuttenhClient.memo.moveOne.pos]["cooldown"]:SetCooldown(GetTime(), cooldown)
					NuttenhClient.memo.itemsFrames[NuttenhClient.memo.moveTwo.pos]["cooldown"]:SetCooldown(GetTime(), cooldown)

					NuttenhClient.memo.inCooldown = true

					NuttenhClient.memo.moveOne.id = nil
					NuttenhClient.memo.moveTwo.id = nil

					wait(cooldown, function()
						NuttenhClient.memo.inCooldown = false

						NuttenhClient.memo.itemsFrames[NuttenhClient.memo.moveOne.pos]["texture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
						NuttenhClient.memo.itemsFrames[NuttenhClient.memo.moveTwo.pos]["texture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

						NuttenhClient.memo.openedFrames =  NuttenhClient.memo.openedFrames - 1
					end)
				end
			else
				NuttenhClient.memo.moveTwo.id = nil

				NuttenhClient.memo.moveTwo.pos = nil
				-- Premier tour
				NuttenhClient.memo.moveOne.id = NuttenhClient.memo.itemsFrames[i]["itemId"]
				NuttenhClient.memo.moveOne.pos = i
			end

			NuttenhClient.memo.itemsFrames[i]["texture"]:SetTexture(GetItemIcon(itemId))
		end
	end)
end

function getRandomItems(amount)
	NuttenhClient.memo.memo_frame:Show()

	local a = {}
	for i=0, amount do
		local v = MEMO_ITEMS_LIST[math.random(#MEMO_ITEMS_LIST)]
		table.remove(MEMO_ITEMS_LIST, getArrayIndex(MEMO_ITEMS_LIST, v))
		a[getArraySize(a)] = v
	end

	local b = concatArray(a, a)
	local positions = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}

	-- Génération du tableau
	for e=1, 12 do
		local pos = positions[math.random(#positions)]
		table.remove(positions, getArrayIndex(positions, pos))

		if e <= 4 then
			addIcon(b[pos], 90 - (60 * mod(e - 1, 4)), 25)
		elseif e <= 8 then
			addIcon(b[pos], 90 - (60 * mod(e - 1, 4)), 85)
		else
			addIcon(b[pos], 90 - (60 * mod(e - 1, 4)), 145)
		end

		NuttenhClient.memo.itemPositions[getArraySize(NuttenhClient.memo.itemPositions)] = b[pos]
	end
end

for i=0, getArraySize(NuttenhClient.memo.itemPositions) - 1 do
	local nbSolutions = getArraySize(NuttenhClient.memo.itemPositions) / 2
	local solutions = {}

	if i <= nbSolutions then
		-- Première partie (0-6)
		solutions[i] = {id=NuttenhClient.memo.itemPositions[i], }
	end

	print(i .. " : " .. NuttenhClient.memo.itemPositions[i])
end