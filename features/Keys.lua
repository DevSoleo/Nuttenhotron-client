function readKey(key, stade)
    -- On définit la liste des caractères autorisés dans un clé
    local settings_values = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                            "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                            "U", "V", "W", "X", "Y", "Z"}
    local groups = {}
    local group_size = 2 -- On définit la taille de chaque groupe

    for i = 1, #key, group_size do
        groups[#groups + 1] = key:sub(i, i + group_size - 1)
    end

    local group = tostring(groups[stade])
    local mission_type = group:sub(1, 1)
    local setting = tostring(group:sub(2, 2))

    return {mission_type=mission_type, setting=setting}
end