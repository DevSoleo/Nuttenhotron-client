function getPlayerCoords()
    -- CATA
    SetMapToCurrentZone()
    local x, y = GetPlayerMapPosition("player")

    -- BFA 
    -- local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()

    local zone_text = GetZoneText()
    local sub_zone_text = GetSubZoneText()

    x = x * 100
    y = y * 100

    return {x=x, y=y, zone_text=zone_text, sub_zone_text=sub_zone_text};
end

function getClassColor(className)
    local classes = {}

    classes["DEATHKNIGHT"] = {rgb={r=196, g=30, b=59}, hex="#C41F3B"}
    classes["DRUID"] = {rgb={r=255, g=125, b=10}, hex="#FF7D0A"}
    classes["HUNTER"] = {rgb={r=171, g=212, b=115}, hex="#ABD473"}
    classes["MAGE"] = {rgb={r=105, g=204, b=240}, hex="#69CCF0"}
    classes["PALADIN"] = {rgb={r=245, g=140, b=186}, hex="#F58CBA"}
    classes["PRIEST"] = {rgb={r=255, g=255, b=255}, hex="#FFFFFF"}
    classes["ROGUE"] = {rgb={r=255, g=245, b=105}, hex="#FFF569"}
    classes["SHAMAN"] = {rgb={r=0, g=112, b=22}, hex="#0070DE"}
    classes["WARLOCK"] = {rgb={r=148, g=130, b=201}, hex="#9482C9"}
    classes["WARRIOR"] = {rgb={r=199, g=156, b=110}, hex="#C79C6E"}

    return classes[className]
end    

function get_target_type(e)
    local id = tonumber(e:sub(5, 5), 16) % 8
    local types = {
        [0] = "player", [3] = "npc", [4] = "pet", [5] = "vehicle"
    }

    return types[id]
end