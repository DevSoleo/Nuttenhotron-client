SLASH_PARTICIPER1 = "/participer"
SLASH_PREUVE1 = "/preuve"

SlashCmdList["PARTICIPER"] = function(msg)
	if vGet("isStarted") == false then
		vSave("isLate", true)
		
		SendChatMessage("Retardataire ".. UnitName("player") .. " souhaite aussi participer à l'event !", "GUILD")
	else
		print("|cfff050f3Vous êtes déjà inscrit dans un event !")
	end
end

SlashCmdList["PREUVE"] = function(msg)
	local command = str_split(msg, " ")

	if time() < vGet("proof-maxtime") and vGet("isWinner") and command[1] == vGet("proof-key") then
		-- On génère ici la clé de victoire
		local time = str_split_chunk(time(), 1)
		local result = ""

		local alphabet = {"N", "Y", "e", "F", "g", "H", "G", "D", "a"}
		alphabet[0] = "i"

		for i=1, array_size(time) - 4 do
		   result = result .. alphabet[tonumber(math.random(0, 9))]
		end

		for i=1, array_size(time) do
		   if i > array_size(time) - 4 then
		      result = result .. alphabet[tonumber(time[i])]
		   end
		end

		SendChatMessage("---- " .. UnitName("player") .. " a gagné ! Clé de victoire : " .. result .. " ----", "GUILD")
	else
		message("Vous n'avez pas l'autorisation d'utiliser cette commande OU la clé utilisée est invalide.")
	end
end