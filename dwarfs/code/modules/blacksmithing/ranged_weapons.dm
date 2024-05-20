/obj/item/gun/crossbow
	name = "crossbow"
	desc = "A mechanical marvel of engineering made to strike your enemies from afar."
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	icon = 'dwarfs/icons/items/weapons.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "crossbow"
	inhand_icon_state = "crossbow"
	worn_icon_state = "crossbow"
	materials = list(PART_PLANKS=/datum/material/wood/treated, PART_HEAD=/datum/material/iron, PART_STRING=/datum/material/cloth/pig_tail_cotton)
	dry_fire_sound = null
	fire_sound = 'dwarfs/sounds/tools/crossbow/shot.wav'
	ranged_skill = /datum/skill/ranged/crossbow

/obj/item/gun/crossbow/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, use_grades=TRUE, inhand_icon_wielded="crossbow_w")

/obj/item/gun/crossbow/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_HEAD], materials[PART_STRING]))

/obj/item/gun/crossbow/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = I
		if(AC.caliber != CALIBER_CROSSBOW)
			return
		playsound(src, 'dwarfs/sounds/tools/crossbow/reload.wav', 80, TRUE)
		to_chat(user, span_notice("You start arming [src]..."))
		var/time = 1.5 SECONDS * toolspeed
		var/action_flags = NONE
		if(ranged_skill)
			time *= user.get_skill_modifier(ranged_skill, SKILL_SPEED_MODIFIER)
		if(user.get_skill_level(ranged_skill) >= 5)
			action_flags = IGNORE_USER_LOC_CHANGE
		if(do_after(user, time, src, action_flags))
			AC.forceMove(src)
			chambered = AC
			update_appearance()

/obj/item/gun/crossbow/can_shoot()
	return HAS_TRAIT(src, TRAIT_WIELDED)

/obj/item/gun/crossbow/shoot_with_empty_chamber(mob/living/user)
	if(!chambered)
		. = ..()
	else
		to_chat(user, span_danger("[src] cannot be shot with one hand!"))

/obj/item/gun/crossbow/handle_chamber(empty_chamber, from_firing, chamber_next_round)
	QDEL_NULL(chambered)

/obj/item/gun/crossbow/update_overlays()
	. = ..()
	if(chambered)
		var/icon/I = chambered.get_material_icon(initial(icon), "crossbow_arrow")
		. += I

/obj/item/gun/crossbow/update_icon_state()
	. = ..()
	if(chambered)
		icon_state = "crossbow_armed"
	else
		icon_state = "crossbow"

/obj/item/gun/crossbow/apply_grade(_grade)
	. = ..()
	switch(grade)
		if(1)
			toolspeed = 2
			extra_damage = -1
			extra_penetration = 0
		if(2)
			toolspeed = 1.1
			extra_damage = 1
			extra_penetration = 1
		if(3)
			toolspeed = 1
			extra_damage = 3
			extra_penetration = 3
		if(4)
			toolspeed = 0.9
			extra_damage = 4
			extra_penetration = 4
		if(5)
			toolspeed = 0.8
			extra_damage = 6
			extra_penetration = 6
		if(6)
			toolspeed = 0.6
			extra_damage = 9
			extra_penetration = 9

/obj/item/ammo_casing/caseless/crossbow_arrow
	name = "bolt"
	desc = "Used as ammunition for a crossbow."
	icon_state = "crossbow_arrow"
	projectile_type = /obj/projectile/bullet/reusable/crossbow_arrow
	materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	caliber = CALIBER_CROSSBOW

/obj/item/ammo_casing/caseless/crossbow_arrow/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/projectile/bullet/reusable/crossbow_arrow
	name = "bolt"
	icon_state = "crossbow_arrow"
	ammo_type = /obj/item/ammo_casing/caseless/crossbow_arrow

/obj/projectile/bullet/reusable/crossbow_arrow/apply_grade(_grade)
	. = ..()
	switch(grade)
		if(1)
			damage = 14
			armour_penetration = 0
		if(2)
			damage = 16
			armour_penetration = 2
		if(3)
			damage = 18
			armour_penetration = 5
		if(4)
			damage = 20
			armour_penetration = 10
		if(5)
			damage = 22
			armour_penetration = 15
		if(6)
			damage = 25
			armour_penetration = 20

/obj/item/gun/bow
	name = "bow"
	desc = "A basic tool for ranged combat."
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	icon = 'dwarfs/icons/items/weapons.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "bow"
	inhand_icon_state = "bow"
	worn_icon_state = "bow"
	materials = list(PART_PLANKS=/datum/material/wood/treated, PART_STRING=/datum/material/cloth/pig_tail_cotton)
	dry_fire_sound = null
	fire_sound = 'dwarfs/sounds/tools/bow/shot.wav'
	ranged_skill = /datum/skill/ranged/bow

/obj/item/gun/bow/Initialize()
	. = ..()
	AddComponent(/datum/component/two_handed, use_grades=TRUE)

/obj/item/gun/bow/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_STRING]))

/obj/item/gun/bow/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = I
		if(AC.caliber != CALIBER_ARROW)
			return
		if(!user.is_holding(src))
			to_chat(user, span_warning("Cannot arm [src] without holding it."))
			return
		playsound(src, 'dwarfs/sounds/tools/bow/draw.wav', 80, TRUE)
		to_chat(user, span_notice("You start arming [src]..."))
		var/time = 1.5 SECONDS
		var/action_flags = NONE
		if(ranged_skill)
			time *= user.get_skill_modifier(ranged_skill, SKILL_SPEED_MODIFIER)
		if(user.get_skill_level(ranged_skill) >= 5)
			action_flags = IGNORE_USER_LOC_CHANGE
		if(do_after(user, time, src, action_flags))
			AC.forceMove(src)
			chambered = AC
			update_appearance()
			user.swap_hand()
			user.activate_hand(user.active_hand_index)

/obj/item/gun/bow/dropped(mob/user)
	. = ..()
	if(chambered)
		chambered.forceMove(get_turf(src))
		chambered = null
		update_appearance()

/obj/item/gun/bow/can_shoot()
	return HAS_TRAIT(src, TRAIT_WIELDED)

/obj/item/gun/bow/shoot_with_empty_chamber(mob/living/user)
	if(!chambered)
		. = ..()
	else
		to_chat(user, span_danger("[src] cannot be shot with one hand!"))

/obj/item/gun/bow/handle_chamber(empty_chamber, from_firing, chamber_next_round)
	QDEL_NULL(chambered)

/obj/item/gun/bow/update_overlays()
	. = ..()
	if(chambered)
		var/icon/I = chambered.get_material_icon(initial(icon), "bow_arrow")
		. += I

/obj/item/gun/bow/update_icon_state()
	. = ..()
	if(chambered)
		icon_state = "bow_armed"
	else
		icon_state = "bow"

/obj/item/ammo_casing/caseless/bow_arrow
	name = "arrow"
	desc = "Used as ammunition for a bow."
	icon_state = "bow_arrow"
	inhand_icon_state = "bow_arrow"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	projectile_type = /obj/projectile/bullet/reusable/bow_arrow
	materials = list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/iron)
	caliber = CALIBER_ARROW

/obj/item/ammo_casing/caseless/bow_arrow/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/projectile/bullet/reusable/bow_arrow
	name = "arrow"
	icon_state = "bow_arrow"
	ammo_type = /obj/item/ammo_casing/caseless/bow_arrow

/obj/projectile/bullet/reusable/bow_arrow/apply_grade(_grade)
	. = ..()
	switch(grade)
		if(1)
			damage = 10
			armour_penetration = 0
		if(2)
			damage = 13
			armour_penetration = 1
		if(3)
			damage = 15
			armour_penetration = 3
		if(4)
			damage = 18
			armour_penetration = 6
		if(5)
			damage = 20
			armour_penetration = 10
		if(6)
			damage = 23
			armour_penetration = 15
