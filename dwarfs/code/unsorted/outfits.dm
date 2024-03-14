/datum/outfit/dwarf
	name = "Dwarf"
	uniform = /obj/item/clothing/under/tunic/random
	belt = /obj/item/flashlight/fueled/lantern
	belt_materials = /datum/material/copper
	shoes = /obj/item/clothing/shoes/boots


/*
Below here are selectable loadouts via prefernces.
If you want them to actualy show up, go to code\modules\client\preferences.dm on line 2 and add them to the list
*/
/datum/outfit/dwarf/miner
	name = "Dwarf miner"
	back = /obj/item/pickaxe
	back_grade = 1
	back_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)
	l_hand = /obj/item/shovel
	l_hand_grade = 1
	l_hand_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)

/datum/outfit/dwarf/farmer
	name = "Dwarf farmer"
	r_hand = /obj/item/hoe
	r_hand_grade = 1
	r_hand_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)
	head = /obj/item/reagent_containers/glass/bucket
	head_materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/copper)

/datum/outfit/dwarf/logger
	name = "Dwarf logger"
	back = /obj/item/axe
	back_grade = 1
	back_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)

/datum/outfit/dwarf/mason
	name = "Dwarf mason"
	l_hand = /obj/item/chisel
	l_hand_grade = 1
	l_hand_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)

/datum/outfit/dwarf/chef
	name = "Dwarf chef"
	r_hand = /obj/item/kitchen/knife
	r_hand_grade = 1
	r_hand_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)
	l_hand = /obj/item/kitchen/rollingpin
	l_hand_grade = 1
	l_hand_materials = /datum/material/wood/pine/treated

/datum/outfit/dwarf/blacksmith
	name = "Dwarf blacksmith"
	r_hand = /obj/item/tongs
	r_hand_grade = 1
	r_hand_materials = /datum/material/copper
	l_hand = /obj/item/smithing_hammer
	l_hand_grade = 1
	l_hand_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)

/datum/outfit/dwarf/builder
	name = "Dwarf builder"
	r_hand = /obj/item/builder_hammer
	r_hand_grade = 1
	r_hand_materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/copper)

/************************************************************************************************************************/
/***********************************************Admin spawnable loadouts below*******************************************/
/************************************************************************************************************************/

/********************************************************DWARF OUTFITS***************************************************/

/datum/outfit/dwarf/king
	name = "Dwarf King"
	head = /obj/item/clothing/head/crown
	head_grade = 1
	l_hand = /obj/item/scepter
	l_hand_grade = 1

/datum/outfit/dwarf_recruit
	name = "Dwarf Recruit"
	skills = list(/datum/skill/combat/spear=2)
	suit_store = /obj/item/spear
	suit_store_grade = 1
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/copper)
	uniform = /obj/item/clothing/under/tunic/random
	suit = /obj/item/clothing/suit/light_plate
	suit_grade = 1
	suit_materials = /datum/material/copper
	shoes = /obj/item/clothing/shoes/leather_boots
	shoes_grade = 1

/datum/outfit/dwarf_wrestler
	name = "Dwarf Wrestler"
	skills = list(/datum/skill/combat/martial=4)
	uniform = /obj/item/clothing/under/tunic/random
	shoes = /obj/item/clothing/shoes/leather_boots
	shoes_grade = 1
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 1

/datum/outfit/dwarf_spearman
	name = "Dwarf Spearman"
	skills = list(/datum/skill/combat/spear=6)
	suit_store = /obj/item/spear
	suit_store_grade = 2
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	uniform = /obj/item/clothing/under/tunic/random
	suit = /obj/item/clothing/suit/light_plate
	suit_grade = 2
	suit_materials = /datum/material/bronze
	head = /obj/item/clothing/head/light_plate
	head_grade = 2
	head_materials = /datum/material/bronze
	shoes = /obj/item/clothing/shoes/leather_boots
	shoes_grade = 2
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 2

/datum/outfit/dwarf_hammerman
	name = "Dwarf Hammerman"
	skills = list(/datum/skill/combat/hammer=6)
	suit_store = /obj/item/warhammer
	suit_store_grade = 2
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	uniform = /obj/item/clothing/under/tunic/random
	suit = /obj/item/clothing/suit/light_plate
	suit_grade = 2
	suit_materials = /datum/material/bronze
	head = /obj/item/clothing/head/light_plate
	head_grade = 2
	head_materials = /datum/material/bronze
	shoes = /obj/item/clothing/shoes/leather_boots
	shoes_grade = 2
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 2

/datum/outfit/dwarf_axeman
	name = "Dwarf Axeman"
	skills = list(/datum/skill/combat/axe=7)
	suit_store = /obj/item/battleaxe
	suit_store_grade = 3
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	uniform = /obj/item/clothing/under/tunic/random
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 3
	suit_materials = /datum/material/iron
	head = /obj/item/clothing/head/light_plate
	head_grade = 3
	head_materials = /datum/material/iron
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 3
	shoes_materials = /datum/material/iron
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 3

/datum/outfit/dwarf_halberd
	name = "Dwarf Halberdman"
	skills = list(/datum/skill/combat/halberd=7)
	suit_store = /obj/item/halberd
	suit_store_grade = 3
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	uniform = /obj/item/clothing/under/tunic/random
	head = /obj/item/clothing/head/light_plate
	head_grade = 3
	head_materials = /datum/material/iron
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 3
	suit_materials = /datum/material/iron
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 3
	shoes_materials = /datum/material/iron
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 3

/datum/outfit/dwarf_elite_swordman
	name = "Dwarf Elite Swordman"
	skills = list(/datum/skill/combat/sword=9, /datum/skill/combat/shield=9)
	r_hand = /obj/item/sword
	r_hand_grade = 4
	r_hand_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	l_hand = /obj/item/shield
	l_hand_grade = 4
	l_hand_materials = list(PART_PLANKS=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	uniform = /obj/item/clothing/under/tunic/random
	head = /obj/item/clothing/head/heavy_plate
	head_grade = 4
	head_materials = /datum/material/steel
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 4
	suit_materials = /datum/material/steel
	gloves = /obj/item/clothing/gloves/plate_gloves
	gloves_grade = 4
	gloves_materials = /datum/material/steel
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 4
	shoes_materials = /datum/material/steel

/datum/outfit/dwarf_elite_hammerman
	name = "Dwarf Elite Hammerman"
	skills = list(/datum/skill/combat/hammer=9)
	suit_store = /obj/item/warhammer
	suit_store_grade = 4
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	uniform = /obj/item/clothing/under/tunic/random
	head = /obj/item/clothing/head/heavy_plate
	head_grade = 4
	head_materials = /datum/material/steel
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 4
	suit_materials = /datum/material/steel
	gloves = /obj/item/clothing/gloves/plate_gloves
	gloves_grade = 4
	gloves_materials = /datum/material/steel
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 4
	shoes_materials = /datum/material/steel

/datum/outfit/dwarf_general
	name = "Dwarf General"
	skills = list(/datum/skill/combat/longsword=11)
	suit_store = /obj/item/zwei
	suit_store_grade = 6
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine)
	uniform = /obj/item/clothing/under/tunic/random
	head = /obj/item/clothing/head/heavy_plate
	head_grade = 5
	head_materials = /datum/material/platinum
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 5
	suit_materials = /datum/material/steel
	gloves = /obj/item/clothing/gloves/plate_gloves
	gloves_grade = 5
	gloves_materials = /datum/material/steel
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 5
	shoes_materials = /datum/material/steel

/*******************************************************GOBLIN OUTFITS***************************************************/

/datum/outfit/goblin_concript
	name = "Goblin Conscript"
	skills = list(/datum/skill/combat/dagger=3, /datum/skill/combat/martial=3)
	r_hand = /obj/item/dagger
	r_hand_grade = 1
	r_hand_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/copper)
	uniform = /obj/item/clothing/under/loincloth

/datum/outfit/goblin_spearman
	name = "Goblin Spearman"
	skills = list(/datum/skill/combat/spear=5)
	uniform = /obj/item/clothing/under/loincloth
	shoes = /obj/item/clothing/shoes/leather_boots
	shoes_grade = 2
	suit_store = /obj/item/spear
	suit_store_grade = 2
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	suit = /obj/item/clothing/suit/light_plate
	suit_grade = 2
	suit_materials = /datum/material/copper
	head = /obj/item/clothing/head/light_plate
	head_grade = 2
	head_materials = /datum/material/copper

/datum/outfit/goblin_flailer
	name = "Goblin Flailer"
	skills = list(/datum/skill/combat/flail=5, /datum/skill/combat/shield=5)
	l_hand = /obj/item/shield
	l_hand_grade = 2
	r_hand = /obj/item/flail
	r_hand_grade = 2
	r_hand_materials = /datum/material/iron
	suit = /obj/item/clothing/suit/light_plate
	suit_grade = 2
	suit_materials = /datum/material/copper
	head = /obj/item/clothing/head/light_plate
	head_grade = 2
	head_materials = /datum/material/copper
	uniform = /obj/item/clothing/under/loincloth
	shoes = /obj/item/clothing/shoes/leather_boots
	shoes_grade = 2

/datum/outfit/goblin_axer
	name = "Goblin Axer"
	skills = list(/datum/skill/combat/axe=6)
	suit_store = /obj/item/battleaxe
	suit_store_grade = 3
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	uniform = /obj/item/clothing/under/loincloth
	head = /obj/item/clothing/head/light_plate
	head_grade = 3
	head_materials = /datum/material/bronze
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 3
	suit_materials = /datum/material/bronze
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 3
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 3
	shoes_materials = /datum/material/iron

/datum/outfit/goblin_hammerman
	name = "Goblin Hammerman"
	skills = list(/datum/skill/combat/hammer=6)
	suit_store = /obj/item/warhammer
	suit_store_grade = 3
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	uniform = /obj/item/clothing/under/loincloth
	head = /obj/item/clothing/head/light_plate
	head_grade = 3
	head_materials = /datum/material/bronze
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 3
	suit_materials = /datum/material/bronze
	gloves = /obj/item/clothing/gloves/leather
	gloves_grade = 3
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 3
	shoes_materials = /datum/material/iron

/datum/outfit/goblin_elite_knight
	name = "Goblin Elite Knight"
	skills = list(/datum/skill/combat/sword=8, /datum/skill/combat/shield=8)
	r_hand = /obj/item/sword
	r_hand_grade = 4
	r_hand_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	l_hand = /obj/item/shield
	l_hand_grade = 4
	uniform = /obj/item/clothing/under/loincloth
	head = /obj/item/clothing/head/heavy_plate
	head_grade = 4
	head_materials = /datum/material/iron
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 4
	suit_materials = /datum/material/iron
	gloves = /obj/item/clothing/gloves/plate_gloves
	gloves_grade = 4
	gloves_grade = /datum/material/iron
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 4
	shoes_materials = /datum/material/iron

/datum/outfit/goblin_elite_axer
	name = "Goblin Elite Axer"
	skills = list(/datum/skill/combat/axe=8)
	suit_store = /obj/item/battleaxe
	suit_store_grade = 4
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	uniform = /obj/item/clothing/under/loincloth
	head = /obj/item/clothing/head/heavy_plate
	head_grade = 4
	head_materials = /datum/material/iron
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 4
	suit_materials = /datum/material/iron
	gloves = /obj/item/clothing/gloves/plate_gloves
	gloves_grade = 4
	gloves_grade = /datum/material/iron
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 4
	shoes_materials = /datum/material/iron

/datum/outfit/goblin_warlord
	skills = list(/datum/skill/combat/longsword=11)
	suit_store = /obj/item/zwei
	suit_store_grade = 6
	suit_store_materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/steel)
	uniform = /obj/item/clothing/under/tunic/random
	head = /obj/item/clothing/head/heavy_plate
	head_grade = 5
	head_materials = /datum/material/gold
	suit = /obj/item/clothing/suit/heavy_plate
	suit_grade = 5
	suit_materials = /datum/material/steel
	gloves = /obj/item/clothing/gloves/plate_gloves
	gloves_grade = 5
	gloves_materials = /datum/material/steel
	shoes = /obj/item/clothing/shoes/plate_boots
	shoes_grade = 5
	shoes_materials = /datum/material/steel
