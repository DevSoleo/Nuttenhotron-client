NPC_LIST = {}
ANSWER_LIST = {}
LOCATIONS_LIST = {}
ITEMS_LIST = {}
KILL_LIST = {}
GAMES_LIST = {}

NPC_LIST["1"] = {name="Dtiuju", indication="Bqqb ab rckzwb hzbqhzb yucr à Kcsctdduc."}
NPC_LIST["2"] = {name="Ckrzctècb ruzcèjb", indication="Bqqb ab rckzwb hzbqhzb yucr à Kcsctdduc."}
NPC_LIST["3"] = {name="Kyzjk Okcjb-nb-Xbc", indication="Tq ab rckzwb hzbqhzb yucr à Kcsctdduc."}
NPC_LIST["4"] = {name="Qbjbntq Utqb-nb-Qzjb", indication="Tq ab rckzwb hzbqhzb yucr nuja q'uzgbcsb nb Jkcncuaatq à Fpvuq."}
NPC_LIST["5"] = {name="Rfcuqq", indication="Rfcuqq ab rckzwb à yqzatbzca bjncktra n'Umbckrf, jkrrudbjr à Fpvuq."}
NPC_LIST["6"] = {name="Eubdnb", indication="Tq a'ustr nb q'uzgbcstarb à Cudeufbj, à Zqnzd."}
NPC_LIST["7"] = {name="Fucctakj Vkjba", indication="Fucctakj Vkjba ab rckzwb à yqzatbzca bjncktra n'Umbckrf, jkrrudbjr à Zqnzd."}
NPC_LIST["8"] = {name="Fuzr-okddujnujr Eudaba", indication="Tq ab rckzwb hzbqhzb yucr ycêr nb Cudeufbj à Zqnzd."}
NPC_LIST["9"] = {name="Duquocubc", indication="Tq bar yckgugqbdbjr UXE hzbqhzb yucr..."}
NPC_LIST["10"] = {name="Ujtibj", indication="Ofbcofbm zjb qzdtècb uwbzsqujrb !"}
NPC_LIST["11"] = {name="Gtjkkd", indication="Rcuouaab... Rz wua p ucctwbc."}
NPC_LIST["12"] = {name="Ykddbcudbuz", indication="Tq wbjn nba xcztra à Nuqucuj."}
NPC_LIST["13"] = {name="Xckmk q'Tqqzarcb", indication="Wkza qb cbokjjuîrcbm xuotqbdbjr, tq a'ustr n'zj Sjkdb azc zj ruyta wkqujr à Nuqucuj."}
NPC_LIST["14"] = {name="Nczsuj Scujnb-skzqéb", indication="O'bar zj dbdgcb nb qtszb nba blyqkcurbzca, kj ybzr qb rckzwbc ycêr nz Rkzcjkt n'Ucsbjr à qu Okzckjjb nb squob."}
NPC_LIST["15"] = {name="Vkabyf Itqakj", indication="Vkabyf bar zj nba abokzctarb uz Rkzcjkt n'Ucsbjr à qu Okzckjjb nb squob."}
NPC_LIST["16"] = {name="Q'Brpdtntuj", indication="O'bar zjb scujnb arurzb, hzbqhzb yucr uz Jkcn nz Ocurècb n'Zj'Skck."}
NPC_LIST["17"] = {name="U'nuq", indication="Tq a'ustr nz Juucz nb Afurrcuf."}
NPC_LIST["18"] = {name="Efunsuc", indication="Efunsuc ab rckzwb zj ybz yucrkzr bj Umbckrf, jkrrudbjr à Afurrcuf."}
NPC_LIST["19"] = {name="Lt'ct", indication="Lt'Ct bar zj Juucz hzb q'kj ybzr cbrckzwbc à q'Bar nb qu Wuqqéb n'Kdgcbqzjb."}

ANSWER_LIST["1"] = {question="Quel est le nom du créateur de cet addon ?", answer="soleo"}

LOCATIONS_LIST["1"] = {x="38.9", y="48.7", zoneText="Maison longue de Miwana", indication="Elle se trouve quelque part à Orgrimmar", displayName="Maison longue de Miwana"}
LOCATIONS_LIST["2"] = {x="57.4", y="58.4", zoneText="Orgrimmar", indication="L'orphelinat se trouve quelque part à Orgrimmar", displayName="L'orphelinat d'Orgrimmar"}

ITEMS_LIST["1"] = {id=2070, name="Bleu de Darnassus", amount=10}

KILL_LIST["1"] = {name="Pourceau adulte sauvage", amount=5}
KILL_LIST["2"] = {name="Ecrevisse boueuse", amount=5}

GAMES_LIST["1"] = {name="Mémo"}

--[[
StaticPopupDialogs["a"] = {
   text = "Text à crypter : ",

   button1 = "Valider",
   button2 = "Fermer",
   
   timeout = 0,
   whileDead = true,
   hideOnEscape = true,
   hasEditBox = true,
   
   OnAccept = function(self)
   		local t = enc(self.editBox:GetText())

	   StaticPopupDialogs["b"] = {
		   text = "Résultat : ",
		   
		   button2 = "Fermer",
		   
		   timeout = 0,
		   whileDead = true,
		   hideOnEscape = true,
		   hasEditBox = true,
		   
		   OnShow = function(self)
		      self.editBox:SetText(t)
		   end
		}

		StaticPopup_Show("b")

   end
}
]]