/datum/smithing_recipe
	/// What this recipe is called
	var/name = ""
	/// What are we making
	var/result
	/// If we want to force a resulting material
	var/list/result_material
	/// How much of that item is being made
	var/max_resulting = 1
	/// Whitelisted materials for this recipe
	var/list/whitelisted_materials
	/// Blacklisted materials for this recipe
	var/list/blacklisted_materials
	/// Recipe category
	var/cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/steel
	name = "steel ingot"
	result = /obj/item/ingot
	whitelisted_materials = list(/datum/material/pig_iron)
	result_material = /datum/material/steel
	cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/zwei
	name = "\[part\] zweihander blade"
	result = /obj/item/partial/zwei
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/flail
	name = "\[part\] ball on a chain"
	result = /obj/item/partial/flail
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/sword
	name = "\[part\] sword blade"
	result = /obj/item/partial/sword
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/dagger
	name = "\[part\] dagger"
	result = /obj/item/partial/dagger
	max_resulting = 3
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/battleaxe
	name = "\[part\] battle axe"
	result = /obj/item/partial/battleaxe
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/pickaxe
	name = "\[part\] pickaxe"
	result = /obj/item/partial/pickaxe
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/shovel
	name = "\[part\] shovel"
	result = /obj/item/partial/shovel
	max_resulting = 2
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/warhammer
	name = "\[part\] warhammer"
	result = /obj/item/partial/warhammer
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/axe
	name = "\[part\] axe"
	result = /obj/item/partial/axe
	max_resulting = 2
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/builder_hammer
	name = "\[part\] builder's hammer"
	result = /obj/item/partial/builder_hammer
	max_resulting = 2
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/smithing_hammer
	name = "\[part\] smithing hammer"
	result = /obj/item/partial/smithing_hammer
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/spear
	name = "\[part\] spear"
	result = /obj/item/partial/spear
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/halberd
	name = "\[part\] halberd"
	result = /obj/item/partial/halberd
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/tongs
	name = "tongs"
	result = /obj/item/tongs
	max_resulting = 2
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/chisel
	name = "\[part\] chisel"
	result = /obj/item/partial/chisel
	max_resulting = 2
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/compass_needle
	name = "\[part\] compass needle"
	result = /obj/item/partial/compass_needle
	whitelisted_materials = list(/datum/material/pig_iron)
	cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/magnet_core
	name = "\[part\] magnet core"
	result = /obj/item/partial/magnet_core
	whitelisted_materials = list(/datum/material/pig_iron)
	cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/pot
	name = "cooking pot"
	result = /obj/item/reagent_containers/glass/cooking_pot
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/baking_sheet
	name = "baking sheet"
	result = /obj/item/reagent_containers/glass/baking_sheet
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/cake_pan
	name = "cake pan"
	result = /obj/item/reagent_containers/glass/cake_pan
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/frying_pan
	name = "\[part\] frying pan"
	result = /obj/item/partial/frying_pan
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/light_plate
	name = "chest plate"
	result = /obj/item/clothing/suit/light_plate
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/heavy_plate
	name = "plate armor"
	result = /obj/item/clothing/suit/heavy_plate
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/chainmail
	name = "chainmail"
	result = /obj/item/clothing/under/chainmail
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/heavy_plate_helmet
	name = "heavy plate helmet"
	result = /obj/item/clothing/head/heavy_plate
	max_resulting = 2
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/light_plate_helmet
	name = "light plate helmet"
	result = /obj/item/clothing/head/light_plate
	max_resulting = 2
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/plate_gloves
	name = "plate gloves"
	result = /obj/item/clothing/gloves/plate_gloves
	max_resulting = 3
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/plate_boots
	name = "plate boots"
	result = /obj/item/clothing/shoes/plate_boots
	max_resulting = 3
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/torch_fixture
	name = "torch fixture"
	result = /obj/item/sconce
	max_resulting = 5
	cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/shield_parts
	name = "\[part\] shield"
	result = /obj/item/partial/shield
	cat = SMITHING_RECIPE_WEAPONS

/datum/smithing_recipe/metal_cup
	name = "metal cup"
	result = /obj/item/reagent_containers/glass/cup/metal
	max_resulting = 3
	cat = SMITHING_RECIPE_MISC

// /datum/smithing_recipe/trowel
// 	name = "trowel"
// 	result = /obj/item/trowel
// 	max_resulting = 2

/datum/smithing_recipe/crown
	name = "empty crown"
	result = /obj/item/partial/crown_empty
	cat = SMITHING_RECIPE_ARMOR

/datum/smithing_recipe/scepter
	name = "scepter part"
	result = /obj/item/partial/scepter_part
	cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/lantern_parts
	name = "\[part\] lantern parts"
	result = /obj/item/partial/lantern_parts
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/kitchen_knife
	name = "\[part\] kitchen knife"
	result = /obj/item/partial/kitchen_knife
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/hoe
	name = "\[part\] hoe blade"
	result = /obj/item/partial/hoe
	cat = SMITHING_RECIPE_TOOLS

/datum/smithing_recipe/lock_key
	name = "lock and key"
	result = /obj/effect/key_lock
	cat = SMITHING_RECIPE_MISC

/datum/smithing_recipe/keys
	name = "keys"
	result = /obj/item/key
	max_resulting = 3
	cat = SMITHING_RECIPE_MISC

/datum/crafter_recipe
	/// Displayed name for the recipe
	var/name = "some recipe"
	/// Result obj path
	var/result
	/// How much of the result is spawned
	var/result_amount = 1
	/// Required materials for this recipe
	var/list/reqs
	/// How long does it take to make this recipe
	var/crafting_time = 8 SECONDS
	/// What skill does affect this recipe crafting time
	var/affecting_skill
	/// How much exp towards the affected skill you get for crafting this recipe
	var/exp_gain = 10

/datum/crafter_recipe/workbench_recipe

/datum/crafter_recipe/workbench_recipe/dagger
	name = "dagger"
	result = /obj/item/dagger
	reqs = list(/obj/item/partial/dagger=1, /obj/item/weapon_hilt=1)

/datum/crafter_recipe/workbench_recipe/zwei
	name = "zweihander"
	result = /obj/item/zwei
	reqs = list(/obj/item/stack/sheet/leather = 2, /obj/item/partial/zwei=1, /obj/item/weapon_hilt=1)

/datum/crafter_recipe/workbench_recipe/flail
	name = "flail"
	result = /obj/item/flail
	reqs = list(/obj/item/partial/flail=1, /obj/item/weapon_hilt=1)

/datum/crafter_recipe/workbench_recipe/sword
	name = "sword"
	result = /obj/item/sword
	reqs = list(/obj/item/stack/sheet/leather = 1, /obj/item/partial/sword=1, /obj/item/weapon_hilt=1)

/datum/crafter_recipe/workbench_recipe/spear
	name = "spear"
	result = /obj/item/spear
	reqs = list(/obj/item/partial/spear =1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/halberd
	name = "halberd"
	result = /obj/item/halberd
	reqs = list(/obj/item/partial/halberd =1, /obj/item/stick=1, /obj/item/stack/sheet/leather = 1)

/datum/crafter_recipe/workbench_recipe/crown
	name = "crown"
	result = /obj/item/clothing/head/crown
	reqs = list(/obj/item/stack/sheet/mineral/gem/sapphire = 3, /obj/item/partial/crown_empty = 1)

/datum/crafter_recipe/workbench_recipe/pickaxe
	name = "pickaxe"
	result = /obj/item/pickaxe
	reqs = list(/obj/item/partial/pickaxe=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/warhammer
	name = "warhammer"
	result = /obj/item/warhammer
	reqs = list(/obj/item/partial/warhammer=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/axe
	name = "axe"
	result = /obj/item/axe
	reqs = list(/obj/item/partial/axe=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/battle_axe
	name = "battle axe"
	result = /obj/item/battleaxe
	reqs = list(/obj/item/partial/battleaxe=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/shovel
	name = "shovel"
	result = /obj/item/shovel
	reqs = list(/obj/item/partial/shovel=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/builder_hammer
	name = "builder's hammer"
	result = /obj/item/builder_hammer
	reqs = list(/obj/item/partial/builder_hammer=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/smithing_hammer
	name = "smithing hammer"
	result = /obj/item/smithing_hammer
	reqs = list(/obj/item/partial/smithing_hammer=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/compass
	name = "compass"
	result = /obj/item/compass
	reqs = list(/obj/item/partial/compass_frame=1, /obj/item/partial/compass_needle=1)

/datum/crafter_recipe/workbench_recipe/frying_pan
	name = "frying pan"
	result = /obj/item/reagent_containers/glass/pan
	reqs = list(/obj/item/partial/frying_pan=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/lantern
	name = "lantern"
	result = /obj/item/flashlight/fueled/lantern
	reqs = list(/obj/item/partial/lantern_parts=1, /obj/item/flashlight/fueled/candle=1, /obj/item/stack/glass=2)

/datum/crafter_recipe/workbench_recipe/scepter
	name = "scepter"
	result = /obj/item/scepter
	reqs = list(/obj/item/partial/scepter_part=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/mop
	name = "mop"
	result = /obj/item/mop
	reqs = list(/obj/item/stick=1, /obj/item/stack/sheet/string=5)

/datum/crafter_recipe/workbench_recipe/kitchen_knife
	name = "kitchen knife"
	result = /obj/item/kitchen/knife
	reqs = list(/obj/item/partial/kitchen_knife=1, /obj/item/weapon_hilt=1)

/datum/crafter_recipe/workbench_recipe/hoe
	name = "hoe"
	result = /obj/item/hoe
	reqs = list(/obj/item/partial/hoe=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/chisel
	name = "chisel"
	result = /obj/item/chisel
	reqs = list(/obj/item/partial/chisel=1, /obj/item/stick=1)

/datum/crafter_recipe/workbench_recipe/s_shield
	name = "small shield"
	result = /obj/item/shield
	reqs = list(/obj/item/stack/sheet/planks=4, /obj/item/partial/shield=1)

/datum/crafter_recipe/workbench_recipe/b_shield
	name = "large shield"
	result = /obj/item/shield/large
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/partial/shield=1)

/datum/crafter_recipe/carpenter_recipe
	affecting_skill = /datum/skill/logging

/datum/crafter_recipe/carpenter_recipe/weapon_hilt
	name = "weapon hilt"
	reqs = list(/obj/item/stack/sheet/planks=1)
	result = /obj/item/weapon_hilt

/datum/crafter_recipe/carpenter_recipe/bucket
	name = "bucket"
	reqs = list(/obj/item/stack/sheet/planks=4, /obj/item/ingot=1)
	result = /obj/item/reagent_containers/glass/bucket
	result_amount = 2

/datum/crafter_recipe/carpenter_recipe/regular_plate
	name = "regular plate"
	reqs = list(/obj/item/stack/sheet/planks=1)
	result = /obj/item/reagent_containers/glass/plate/regular

/datum/crafter_recipe/carpenter_recipe/flat_plate
	name = "flat plate"
	reqs = list(/obj/item/stack/sheet/planks=1)
	result = /obj/item/reagent_containers/glass/plate/flat

/datum/crafter_recipe/carpenter_recipe/bowl
	name = "bowl"
	reqs = list(/obj/item/stack/sheet/planks=2)
	result = /obj/item/reagent_containers/glass/plate/bowl

/datum/crafter_recipe/carpenter_recipe/stick
	name = "stick"
	reqs = list(/obj/item/stack/sheet/planks=1)
	result = /obj/item/stick

/datum/crafter_recipe/carpenter_recipe/cup
	name = "wooden cup"
	reqs = list(/obj/item/stack/sheet/planks=3, /obj/item/ingot=1)
	result = /obj/item/reagent_containers/glass/cup/wooden
	result_amount = 3

/datum/crafter_recipe/carpenter_recipe/rolling_pin
	name = "rolling pin"
	reqs = list(/obj/item/stack/sheet/planks=2)
	result = /obj/item/kitchen/rollingpin

/datum/crafter_recipe/carpenter_recipe/club
	name = "club"
	reqs = list(/obj/item/stack/sheet/planks=5)
	result = /obj/item/club

/datum/crafter_recipe/tailor_recipe

/datum/crafter_recipe/tailor_recipe/boots
	name = "boots"
	reqs = list(/obj/item/stack/sheet/cloth=3)
	result = /obj/item/clothing/shoes/boots

/datum/crafter_recipe/tailor_recipe/tunic
	name = "tunic"
	reqs = list(/obj/item/stack/sheet/cloth=6)
	result = /obj/item/clothing/under/tunic/random

/datum/crafter_recipe/tailor_recipe/casing
	name = "stitched casing"
	reqs = list(/obj/item/stack/sheet/cloth=3)
	result = /obj/item/food/intestines/stitched_casing

/datum/crafter_recipe/tailor_recipe/satchel
	name = "satchel"
	reqs = list(/obj/item/stack/sheet/leather=3)
	result = /obj/item/storage/satchel
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/soil_bag
	name = "soil bag"
	reqs = list(/obj/item/stack/sheet/leather=4)
	result = /obj/item/storage/soil
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/grains_sack
	name = "grains sack"
	reqs = list(/obj/item/stack/sheet/cloth=3)
	result = /obj/item/reagent_containers/glass/sack
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/leather_helmet
	name = "leather helmet"
	reqs = list(/obj/item/stack/sheet/leather=4)
	result = /obj/item/clothing/head/leather_helmet
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/leather_vest
	name = "leather vest"
	reqs = list(/obj/item/stack/sheet/leather=6)
	result = /obj/item/clothing/suit/leather_vest
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/leather_boots
	name = "leather boots"
	reqs = list(/obj/item/stack/sheet/leather=4)
	result = /obj/item/clothing/shoes/leather_boots
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/leather_gloves
	name = "leather gloves"
	reqs = list(/obj/item/stack/sheet/leather=2)
	result = /obj/item/clothing/gloves/leather
	affecting_skill = /datum/skill/skinning

/datum/crafter_recipe/tailor_recipe/rag
	name = "rag"
	result = /obj/item/reagent_containers/glass/rag
	reqs = list(/obj/item/stack/sheet/string=3)
