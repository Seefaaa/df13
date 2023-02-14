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
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 5
	atck_type = SHARP
	max_integrity = 150
	resistance_flags = FIRE_PROOF
	reach = 2
	skill = /datum/skill/combat/longsword
	melee_cd = 2 SECONDS

/obj/item/zwei/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/zwei/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/zwei/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))


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
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_simple = list("hit")
	attack_verb_continuous = list("hits")
	block_chance = 0
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/flail
	melee_cd = 1 SECONDS

/obj/item/flail/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/flail/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))

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
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = 'sound/weapons/bladeslice.ogg'
	block_chance = 0
	atck_type = SHARP
	max_integrity = 20
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/dagger
	melee_cd = 0.6 SECONDS

/obj/item/dagger/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/dagger/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))

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
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
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

/obj/item/sword/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/sword/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))

/obj/item/spear
	name = "spear"
	desc = "Spears usually found in dwarven hold barracks but make a great weapon to keep a bigger enemy at the distance."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "spear"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	worn_icon = 'dwarfs/icons/mob/clothing/back.dmi'
	inhand_icon_state = "spear"
	slot_flags = ITEM_SLOT_BACK
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

/obj/item/spear/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, inhand_icon_wielded="spear_w")

/obj/item/spear/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/spear/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))

/obj/item/warhammer
	name = "warhammer"
	desc = "Warhammer makes a great choice for the dwarven warrior. As a natural miners and blacksmiths - it have all same principes of use as common dwarven tools."
	icon = 'dwarfs/icons/items/weapons.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "warhammer"
	w_class = WEIGHT_CLASS_HUGE
	atck_type = BLUNT
	force = 20
	reach = 2
	skill = /datum/skill/combat/hammer
	melee_cd = 1.5 SECONDS

/obj/item/warhammer/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE)

/obj/item/warhammer/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/warhammer/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))

/obj/item/halberd
	name = "halberd"
	desc = "Pointy stick with bladee. Robustester."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "halberd"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "halberd"
	slot_flags = ITEM_SLOT_BACK
	force = 20
	throwforce = 5
	reach = 2
	w_class = WEIGHT_CLASS_HUGE
	hitsound = 'sound/weapons/pierce_slow.ogg'
	block_chance = 15
	atck_type = PIERCE
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	skill = /datum/skill/combat/halberd
	tool_behaviour = TOOL_AXE
	melee_cd = 1.2 SECONDS

/obj/item/halberd/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=5, use_grades=TRUE, inhand_icon_wielded="halberd_w")

/obj/item/halberd/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials[PART_HANDLE], materials[PART_BLADE]))
	var/datum/material/M = get_material(materials[PART_BLADE])
	M.apply_stats(src)

/obj/item/halberd/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_BLADE]))

/obj/item/scepter
	name = "scepter"
	desc = "King's scepter. For him to rule, for you to obey." // also  "King's second most important tool. You hit peasants with it."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "king_scepter"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "king_scepter"
	worn_icon = 'dwarfs/icons/mob/clothing/back.dmi'
	slot_flags = ITEM_SLOT_BACK
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_BULKY
	hitsound = 'sound/weapons/whip.ogg'
	block_chance = 20
	atck_type = BLUNT
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	melee_cd = 0.6 SECONDS

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

/obj/item/club/apply_material(list/_materials)
	. = ..()
	icon = apply_palettes(icon(icon, icon_state), list(materials))
	var/datum/material/M = get_material(materials)
	M.apply_stats(src)

/obj/item/club/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials))
