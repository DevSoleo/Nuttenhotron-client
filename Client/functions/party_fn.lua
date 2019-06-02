-- Cette fonction retournera true si le joueur se trouve dans un groupe, sinon la fonction retounera false
function isInParty()
	return GetNumPartyMembers() > 0
end

function getPartyPlayerList()
	local member_count = 0
	local player_list = {}

	for group_index = 1, 4 do
		if (GetPartyMember(group_index)) then
	  		member_count = member_count + 1
	  		player_list[get_array_size(player_list)] = UnitName("party" .. tostring(member_count)):sub(1, -1)
		end
	end

	return playerList
end