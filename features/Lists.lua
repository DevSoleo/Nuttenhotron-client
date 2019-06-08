NPC_LIST = {}
ANSWER_LIST = {}
LOCATIONS_LIST = {}
ITEMS_LIST = {}
KILL_LIST = {}

function loadLists()
	NPC_LIST["1"] = {name="Miwana", indication="Miwana"}
	NPC_LIST["2"] = {name="Roturière taurène", indication="Roturière taurène"}
	NPC_LIST["3"] = {name="Opuno Corne-de-Fer", indication="Opuno Corne-de-Fer"}

	ANSWER_LIST["1"] = {question="Quel est le nom du créateur de cet addon ?", answer="soleo", indication="Quel est le nom du créateur de cet addon ?"}

	LOCATIONS_LIST["1"] = {x="38.9", y="48.7", zoneText={frFR="Maison longue de Miwana", enUS="Miwana's Longhouse"}, subZoneText={frFR="Maison longue de Miwana"}, indication="Miwana"}

	ITEMS_LIST["1"] = {id=2070, name={frFR="Bleu de Darnassus", enUS="Darnassian Bleu"}, amount=10, indication="Bleu de Darnassus"}

	KILL_LIST["1"] = {name={frFR="Pourceau adulte sauvage", enUS=""}, amount=5, indication="Devant Orgrimmar !"}
	KILL_LIST["2"] = {name={frFR="Ecrevisse boueuse", enUS="Muddy Crawfish", esES="Centollo fangoso"}, amount=5, indication="Petites ecrevisses !"}
end

loadLists()