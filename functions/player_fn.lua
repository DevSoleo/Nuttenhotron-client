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