/obj/item/zwei
	name = "zweihander"
	desc = "A long sword, made too big for a dwarf to wield it easily."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "zweihander"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand_96x32.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand_96x32.dmi'
	inhand_icon_state = "zweihander"
	inhand_x_dimension = -32
	force = 30
	throwforce = 15
	slot_flags = ITEM_SLOT_SUITSTORE
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 5
	atck_type = SHARP
	max_integrity = 150
	resistance_flags = FIRE_PROOF
	reach = 2
	skill = /datum/skill/combat/longsword
	melee_cd = 2 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/zwei/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))


/obj/item/flail
	name = "flail"
	desc = "Flail to crush your enemies. Lies comfy in one hand."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "cep"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "cep"
	force = 20
	atck_type = BLUNT
	throwforce = 25
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_simple = list("hit")
	attack_verb_continuous = list("hits")
	block_chance = 0
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/flail
	melee_cd = 1 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/flail/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/dagger
	name = "dagger"
	desc = "Dagger - a rare choice for a dwarven warrior. Made for swift cuts and stings."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "dagger"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "dagger"
	force = 8
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 0
	atck_type = SHARP
	max_integrity = 20
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/dagger
	melee_cd = 0.6 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/dagger/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/*
/obj/item/dagger/Initialize()
	. = ..()
	AddComponent(/datum/component/attack_toggle,\
		attacks=list(SHARP,PIERCE),\
		damages=list(20, 3),\
		cooldowns=list(CLICK_CD_MELEE, CLICK_CD_RAPID),\
		attack_verbs_simple=list(list("attack","slash"), list("pierce","poke","stab")),\
		attack_verbs_continuous=list(list("attacks","slashes"), list("pierces","pokes","stabs"))\
	)
*/
/obj/item/sword
	name = "sword"
	desc = "A straight sword with double edge. More commonly found in human cities."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "sword"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "sword"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT | ITEM_SLOT_SUITSTORE
	force = 30
	throwforce = 20
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 15
	atck_type = SHARP
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/sword
	melee_cd = 1 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/sword/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/spear
	name = "spear"
	desc = "Spears usually found in dwarven hold barracks but make a great weapon to keep a bigger enemy at the distance."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "spear"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "spear"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	force = 20
	throwforce = 30
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/pierce_slow.ogg'
	block_chance = 5
	reach = 2
	atck_type = PIERCE
	max_integrity = 50
	skill = /datum/skill/combat/spear
	melee_cd = 1.2 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/spear/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, inhand_icon_wielded="spear_w")

/obj/item/spear/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/warhammer
	name = "warhammer"
	desc = "Warhammer makes a great choice for the dwarven warrior. As a natural miners and blacksmiths - it have all same principes of use as common dwarven tools."
	icon = 'dwarfs/icons/items/weapons.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "warhammer"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE
	atck_type = BLUNT
	force = 20
	reach = 2
	skill = /datum/skill/combat/hammer
	melee_cd = 1.5 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/warhammer/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/warhammer/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/halberd
	name = "halberd"
	desc = "Pointy stick with bladee. Robustester."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "halberd"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "halberd"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	force = 20
	throwforce = 5
	reach = 2
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/pierce_slow.ogg'
	block_chance = 15
	atck_type = PIERCE
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/halberd
	tool_behaviour = TOOL_AXE
	melee_cd = 1.2 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/halberd/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, inhand_icon_wielded="halberd_w")

/obj/item/halberd/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/scepter
	name = "scepter"
	desc = "King's scepter. For him to rule, for you to obey." // also  "King's second most important tool. You hit peasants with it."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "king_scepter"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "king_scepter"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/whip.ogg'
	block_chance = 20
	atck_type = BLUNT
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	melee_cd = 0.6 SECONDS
	///Cooldown between stuns
	var/cooldown = 2 SECONDS
	var/next_stun = 0
	///How long do we stun the target for
	var/stun_duration = 1.5 SECONDS

/obj/item/scepter/attack(mob/living/M, mob/living/user, params)
	. = ..()
	if(.)
		return
	if(ishuman(M) && world.time >= next_stun)
		next_stun = world.time + cooldown
		var/mob/living/carbon/human/target = M
		target.Knockdown(stun_duration)
		target.apply_damage(rand(6, 12), STAMINA)

/obj/item/club
	name = "club"
	desc = "You hit head with it."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "club"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	force = 13
	throwforce = 10
	atck_type = BLUNT
	w_class = WEIGHT_CLASS_BULKY
	materials = /datum/material/wood/towercap/treated

/obj/item/club/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials))

/obj/item/shield
	name = "shield"
	icon = 'dwarfs/icons/items/weapons.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "small_shield"
	slot_flags = ITEM_SLOT_BACK
	block_chance = 30
	force = 5
	parry_cooldown = 0.3 SECONDS
	atck_type = BLUNT
	w_class = WEIGHT_CLASS_BULKY
	parrysound = 'dwarfs/sounds/weapons/shield/shield_parry.ogg'
	skill = /datum/skill/combat/shield
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)

/obj/item/shield/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/item/shield/large
	name = "large shield"
	icon_state = "big_shield"
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	block_chance = 40

/obj/item/shield/large/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, require_twohands=TRUE)

/obj/item/battleaxe
	name = "battleaxe"
	desc = "A handy tool for chopping your enemies."
	icon = 'dwarfs/icons/items/weapons.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "battleaxe"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE
	atck_type = SHARP
	tool_behaviour = TOOL_AXE
	toolspeed = 2
	force = 20
	skill = /datum/skill/combat/axe
	melee_cd = 1 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)

/obj/item/battleaxe/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/battleaxe/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))
