/datum/smithing_recipe
	/// What this recipe is called
	var/name = ""
	/// What are we making
	var/result
	/// How much of that item is being made
	var/max_resulting = 1

/datum/smithing_recipe/zwei
	name = "\[part\] zweihander blade"
	result = /obj/item/partial/zwei

/datum/smithing_recipe/flail
	name = "\[part\] ball on a chain"
	result = /obj/item/partial/flail

/datum/smithing_recipe/sword
	name = "\[part\] sword blade"
	result = /obj/item/partial/sword

/datum/smithing_recipe/dagger
	name = "\[part\] dagger"
	result = /obj/item/partial/dagger
	max_resulting = 3

/datum/smithing_recipe/battleaxe
	name = "\[part\] battle axe"
	result = /obj/item/partial/battleaxe

/datum/smithing_recipe/pickaxe
	name = "\[part\] pickaxe"
	result = /obj/item/partial/pickaxe

/datum/smithing_recipe/shovel
	name = "\[part\] shovel"
	result = /obj/item/partial/shovel
	max_resulting = 2

/datum/smithing_recipe/warhammer
	name = "\[part\] warhammer"
	result = /obj/item/partial/warhammer

/datum/smithing_recipe/axe
	name = "\[part\] axe"
	result = /obj/item/partial/axe
	max_resulting = 2

/datum/smithing_recipe/builder_hammer
	name = "\[part\] builder's hammer"
	result = /obj/item/partial/builder_hammer
	max_resulting = 2

/datum/smithing_recipe/smithing_hammer
	name = "\[part\] smithing hammer"
	result = /obj/item/partial/smithing_hammer

/datum/smithing_recipe/spear
	name = "\[part\] spear"
	result = /obj/item/partial/spear

/datum/smithing_recipe/halberd
	name = "\[part\] halberd"
	result = /obj/item/partial/halberd

/datum/smithing_recipe/tongs
	name = "tongs"
	result = /obj/item/tongs
	max_resulting = 2

/datum/smithing_recipe/chisel
	name = "\[part\] chisel"
	result = /obj/item/partial/chisel
	max_resulting = 2

/datum/smithing_recipe/pan
	name = "frying pan"
	result = /obj/item/reagent_containers/glass/pan

/datum/smithing_recipe/pot
	name = "cooking pot"
	result = /obj/item/reagent_containers/glass/cooking_pot

/datum/smithing_recipe/baking_sheet
	name = "baking sheet"
	result = /obj/item/reagent_containers/glass/baking_sheet

/datum/smithing_recipe/cake_pan
	name = "cake pan"
	result = /obj/item/reagent_containers/glass/cake_pan

/datum/smithing_recipe/light_plate
	name = "chest plate"
	result = /obj/item/clothing/suit/light_plate

/datum/smithing_recipe/heavy_plate
	name = "plate armor"
	result = /obj/item/clothing/suit/heavy_plate

/datum/smithing_recipe/chainmail
	name = "chainmail"
	result = /obj/item/clothing/under/chainmail

/datum/smithing_recipe/plate_helmet
	name = "plate helmet"
	result = /obj/item/clothing/head/plate_helmet
	max_resulting = 2

/datum/smithing_recipe/plate_gloves
	name = "plate gloves"
	result = /obj/item/clothing/gloves/plate_gloves
	max_resulting = 3

/datum/smithing_recipe/plate_boots
	name = "plate boots"
	result = /obj/item/clothing/shoes/plate_boots
	max_resulting = 3

/datum/smithing_recipe/torch_fixture
	name = "torch fixture"
	result = /obj/item/sconce
	max_resulting = 5

// /datum/smithing_recipe/trowel
// 	name = "trowel"
// 	result = /obj/item/trowel
// 	max_resulting = 2

/datum/smithing_recipe/crown
	name = "empty crown"
	result = /obj/item/partial/crown_empty

/datum/smithing_recipe/scepter
	name = "scepter part"
	result = /obj/item/partial/scepter_part

/datum/smithing_recipe/lantern_parts
	name = "\[part\] lantern parts"
	result = /obj/item/partial/lantern_parts

/datum/smithing_recipe/kitchen_knife
	name = "\[part\] kitchen knife"
	result = /obj/item/partial/kitchen_knife

/datum/smithing_recipe/hoe
	name = "\[part\] hoe blade"
	result = /obj/item/partial/hoe

/datum/smithing_recipe/lock_key
	name = "Lock and key"
	result = /obj/effect/key_lock

/datum/smithing_recipe/keys
	name = "Keys"
	result = /obj/item/key
	max_resulting = 3

/datum/workbench_recipe
	var/name = "workbench_recipe"
	var/result
	var/list/reqs

/datum/workbench_recipe/dagger
	name = "dagger"
	result = /obj/item/dagger
	reqs = list(/obj/item/partial/dagger=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/zwei
	name = "zweihander"
	result = /obj/item/zwei
	reqs = list(/obj/item/stack/sheet/leather = 2, /obj/item/partial/zwei=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/flail
	name = "flail"
	result = /obj/item/flail
	reqs = list(/obj/item/partial/flail=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/sword
	name = "sword"
	result = /obj/item/sword
	reqs = list(/obj/item/stack/sheet/leather = 1, /obj/item/partial/sword=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/spear
	name = "spear"
	result = /obj/item/spear
	reqs = list(/obj/item/partial/spear =1, /obj/item/stick=1)

/datum/workbench_recipe/halberd
	name = "halberd"
	result = /obj/item/halberd
	reqs = list(/obj/item/partial/halberd =1, /obj/item/stick=1, /obj/item/stack/sheet/leather = 1)

/datum/workbench_recipe/crown
	name = "crown"
	result = /obj/item/clothing/head/crown
	reqs = list(/obj/item/stack/sheet/mineral/gem/sapphire = 3, /obj/item/partial/crown_empty = 1)

/datum/workbench_recipe/pickaxe
	name = "pickaxe"
	result = /obj/item/pickaxe
	reqs = list(/obj/item/partial/pickaxe=1, /obj/item/stick=1)

/datum/workbench_recipe/warhammer
	name = "warhammer"
	result = /obj/item/warhammer
	reqs = list(/obj/item/partial/warhammer=1, /obj/item/stick=1)

/datum/workbench_recipe/axe
	name = "axe"
	result = /obj/item/axe
	reqs = list(/obj/item/partial/axe=1, /obj/item/stick=1)

/datum/workbench_recipe/axe
	name = "battle axe"
	result = /obj/item/battleaxe
	reqs = list(/obj/item/partial/battleaxe=1, /obj/item/stick=1)

/datum/workbench_recipe/shovel
	name = "shovel"
	result = /obj/item/shovel
	reqs = list(/obj/item/partial/shovel=1, /obj/item/stick=1)

/datum/workbench_recipe/builder_hammer
	name = "builder's hammer"
	result = /obj/item/builder_hammer
	reqs = list(/obj/item/partial/builder_hammer=1, /obj/item/stick=1)

/datum/workbench_recipe/smithing_hammer
	name = "smithing hammer"
	result = /obj/item/smithing_hammer
	reqs = list(/obj/item/partial/smithing_hammer=1, /obj/item/stick=1)

/datum/workbench_recipe/lantern
	name = "lantern"
	result = /obj/item/flashlight/fueled/lantern
	reqs = list(/obj/item/partial/lantern_parts=1, /obj/item/flashlight/fueled/candle=1, /obj/item/stack/glass=2)

/datum/workbench_recipe/scepter
	name = "scepter"
	result = /obj/item/scepter
	reqs = list(/obj/item/partial/scepter_part=1, /obj/item/stick=1)

/datum/workbench_recipe/mop
	name = "mop"
	result = /obj/item/mop
	reqs = list(/obj/item/stick=1, /obj/item/stack/sheet/string=5)

/datum/workbench_recipe/rag
	name = "rag"
	result = /obj/item/reagent_containers/glass/rag
	reqs = list(/obj/item/stack/sheet/string=3)

/datum/workbench_recipe/kitchen_knife
	name = "kitchen knife"
	result = /obj/item/kitchen/knife
	reqs = list(/obj/item/partial/kitchen_knife=1, /obj/item/weapon_hilt=1)

/datum/workbench_recipe/hoe
	name = "hoe"
	result = /obj/item/hoe
	reqs = list(/obj/item/partial/hoe=1, /obj/item/stick=1)

/datum/workbench_recipe/chisel
	name = "chisel"
	result = /obj/item/chisel
	reqs = list(/obj/item/partial/chisel=1, /obj/item/stick=1)

/datum/workbench_recipe/s_shield
	name = "small shield"
	result = /obj/item/shield
	reqs = list(/obj/item/stack/sheet/planks=4, /obj/item/ingot=1)

/datum/workbench_recipe/b_shield
	name = "large shield"
	result = /obj/item/shield/large
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/ingot=2)
