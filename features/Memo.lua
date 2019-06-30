NuttenhAdmin.memo = {}

-- Création de la fenêtre principale
NuttenhAdmin.memo.memo_frame = CreateFrame("Frame", nil, UIParent)
NuttenhAdmin.memo.memo_frame:SetFrameStrata("BACKGROUND")
NuttenhAdmin.memo.memo_frame:SetWidth(250)
NuttenhAdmin.memo.memo_frame:SetHeight(250)

NuttenhAdmin.memo.memo_frame:SetBackdrop({
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

NuttenhAdmin.memo.memo_frame:SetBackdropColor(0, 0, 0)
NuttenhAdmin.memo.memo_frame:SetPoint("CENTER", 0, 20)

NuttenhAdmin.memo.memo_frame:Hide()

NuttenhAdmin.memo.title = NuttenhAdmin.memo.memo_frame:CreateFontString(nil, "ARTWORK")
NuttenhAdmin.memo.title:SetFont("Fonts\\FRIZQT__.TTF", 14)
NuttenhAdmin.memo.title:SetPoint("TOP", 0, -30)
NuttenhAdmin.memo.title:SetText("Résolvez le mémo suivant :")
NuttenhAdmin.memo.title:SetTextColor(255, 255, 255, 1)

NuttenhAdmin.memo.itemsFrames = {}
-- NuttenhAdmin.memo.openedFrames : stocke le nombre de frames d'items actuellement ouvertes
NuttenhAdmin.memo.openedFrames = 0

-- NuttenhAdmin.memo.totalMove : stocke le nombre TOTAL de tours
NuttenhAdmin.memo.totalMoves = 0

-- NuttenhAdmin.memo.points : stocke le nombre de points gagnés par le joueur
NuttenhAdmin.memo.points = 0

NuttenhAdmin.memo.move = nil

NuttenhAdmin.memo.moveOne = {}
NuttenhAdmin.memo.moveTwo = {}

NuttenhAdmin.memo.moveOne.id = nil
NuttenhAdmin.memo.moveTwo.id = nil

NuttenhAdmin.memo.moveOne.pos = nil
NuttenhAdmin.memo.moveTwo.pos = nil

NuttenhAdmin.memo.points = 0
NuttenhAdmin.memo.boxes = 12

NuttenhAdmin.memo.itemPositions = {}

NuttenhAdmin.memo.inCooldown = false

function addIcon(itemId, x, y)
	local i = getArraySize(NuttenhAdmin.memo.itemsFrames)

	NuttenhAdmin.memo.itemsFrames[i] = CreateFrame("Frame", nil, NuttenhAdmin.memo.memo_frame)
	NuttenhAdmin.memo.itemsFrames[i]:SetSize(35, 35)
	NuttenhAdmin.memo.itemsFrames[i]:SetPoint("BOTTOM", x, y)

	NuttenhAdmin.memo.itemsFrames[i]["itemId"] = itemId

	NuttenhAdmin.memo.itemsFrames[i]["texture"] = NuttenhAdmin.memo.itemsFrames[i]:CreateTexture()
	NuttenhAdmin.memo.itemsFrames[i]["texture"]:SetAllPoints()
	NuttenhAdmin.memo.itemsFrames[i]["texture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
	-- NuttenhAdmin.memo.itemsFrames[i]["texture"]:SetTexture(GetItemIcon(itemId)) -- A RETIRER

	NuttenhAdmin.memo.itemsFrames[i]["cooldown"] = CreateFrame("Cooldown", "Memo_Cooldown_" .. i, NuttenhAdmin.memo.itemsFrames[i], "CooldownFrameTemplate")
	NuttenhAdmin.memo.itemsFrames[i]["cooldown"]:SetAllPoints()

	NuttenhAdmin.memo.itemsFrames[i]["cooldown"]:SetCooldown(GetTime(), 0.1)

	NuttenhAdmin.memo.itemsFrames[i]["button"] = CreateFrame("Button", nil, NuttenhAdmin.memo.itemsFrames[i])
	NuttenhAdmin.memo.itemsFrames[i]["button"]:SetFrameStrata("BACKGROUND")
	NuttenhAdmin.memo.itemsFrames[i]["button"]:SetBackdropBorderColor(255, 0, 0, 1)
	NuttenhAdmin.memo.itemsFrames[i]["button"]:SetAllPoints()

	NuttenhAdmin.memo.itemsFrames[i]["button"]:SetScript("OnClick", function(self)
		if NuttenhAdmin.memo.inCooldown == false and i ~= NuttenhAdmin.memo.moveOne.pos then
			local cooldown = 2

			print("ID : " .. i)

			NuttenhAdmin.memo.totalMoves = NuttenhAdmin.memo.totalMoves + 1

			NuttenhAdmin.memo.openedFrames = NuttenhAdmin.memo.openedFrames + 1

			if NuttenhAdmin.memo.totalMoves % 2 == 0 then
				print("SECOND TOUR !")
				-- Second tour
				NuttenhAdmin.memo.moveTwo.id = NuttenhAdmin.memo.itemsFrames[i]["itemId"]
				NuttenhAdmin.memo.moveTwo.pos = i

				if NuttenhAdmin.memo.moveOne.id == NuttenhAdmin.memo.moveTwo.id then
					NuttenhAdmin.memo.moveOne.id = nil
					NuttenhAdmin.memo.moveTwo.id = nil

					NuttenhAdmin.memo.itemsFrames[NuttenhAdmin.memo.moveOne.pos]:Hide()
					NuttenhAdmin.memo.itemsFrames[NuttenhAdmin.memo.moveTwo.pos]:Hide()

					NuttenhAdmin.memo.points = NuttenhAdmin.memo.points + 1

					if NuttenhAdmin.memo.points >= NuttenhAdmin.memo.boxes / 2 then 
						-- Victoire
						NuttenhAdmin.memo.memo_frame:Hide()
						startMission(vGet("key"), vGet("stade") + 1)
					end
				else
					NuttenhAdmin.memo.itemsFrames[NuttenhAdmin.memo.moveOne.pos]["cooldown"]:SetCooldown(GetTime(), cooldown)
					NuttenhAdmin.memo.itemsFrames[NuttenhAdmin.memo.moveTwo.pos]["cooldown"]:SetCooldown(GetTime(), cooldown)

					NuttenhAdmin.memo.inCooldown = true

					NuttenhAdmin.memo.moveOne.id = nil
					NuttenhAdmin.memo.moveTwo.id = nil

					wait(cooldown, function()
						NuttenhAdmin.memo.inCooldown = false

						NuttenhAdmin.memo.itemsFrames[NuttenhAdmin.memo.moveOne.pos]["texture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
						NuttenhAdmin.memo.itemsFrames[NuttenhAdmin.memo.moveTwo.pos]["texture"]:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

						NuttenhAdmin.memo.openedFrames =  NuttenhAdmin.memo.openedFrames - 1
					end)
				end
			else
				NuttenhAdmin.memo.moveTwo.id = nil

				NuttenhAdmin.memo.moveTwo.pos = nil
				print("PREMIER TOUR !")
				-- Premier tour
				NuttenhAdmin.memo.moveOne.id = NuttenhAdmin.memo.itemsFrames[i]["itemId"]
				NuttenhAdmin.memo.moveOne.pos = i
			end

			NuttenhAdmin.memo.itemsFrames[i]["texture"]:SetTexture(GetItemIcon(itemId))
		end
	end)
end

function getRandomItems(amount)
	NuttenhAdmin.memo.memo_frame:Show()

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

		NuttenhAdmin.memo.itemPositions[getArraySize(NuttenhAdmin.memo.itemPositions)] = b[pos]
	end
end

for i=0, getArraySize(NuttenhAdmin.memo.itemPositions) - 1 do
	local nbSolutions = getArraySize(NuttenhAdmin.memo.itemPositions) / 2
	local solutions = {}

	if i <= nbSolutions then
		-- Première partie (0-6)
		solutions[i] = {id=NuttenhAdmin.memo.itemPositions[i], }
	end

	print(i .. " : " .. NuttenhAdmin.memo.itemPositions[i])
end