#define TORCH_LIGHT_COLOR "#FFE0B3"

/obj/item/ingot
	name = "ingot"
	desc = "Can be forged into something."
	icon = 'dwarfs/icons/items/ingots.dmi'
	icon_state = "ingot"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 2
	throwforce = 5
	throw_range = 7
	var/datum/smithing_recipe/recipe = null
	var/durability = 6
	var/progress_current = 0
	var/progress_need = 10
	var/heattemp = 0

/obj/item/ingot/apply_material(list/_materials)
	. = ..()
	var/datum/material/M = SSmaterials.materials[materials]
	name = "[M.name] ingot"
	var/icon/I = M.apply_palette(icon(icon, icon_state), "template1")
	icon = I

/obj/item/ingot/build_worn_with_material(_file, state)
	var/icon/I = ..()
	return apply_palettes(I, list(materials))

/obj/item/ingot/examine(mob/user)
	. = ..()
	var/ct = ""
	switch(heattemp)
		if(200 to INFINITY)
			ct = "red-hot"
		if(100 to 199)
			ct = "very hot"
		if(1 to 99)
			ct = "hot enough"
		else
			ct = "cold"

	. += "<hr>The [src] is [ct]."
	if(recipe)
		. += "<hr> The [src] is being smithed into [recipe.name]."

/obj/item/ingot/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/ingot/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/ingot/process()
	if(!heattemp)
		return
	heattemp = max(heattemp-25, 0)
	update_appearance()
	if(isobj(loc))
		loc.update_appearance()

/obj/item/ingot/update_overlays()
	. = ..()
	var/mutable_appearance/heat = mutable_appearance('dwarfs/icons/items/ingots.dmi', initial(icon_state))
	heat.alpha =  255 * (heattemp / 350)
	. += heat


/obj/item/ingot/attackby(obj/item/I, mob/living/user, params)

	if(user.a_intent == INTENT_HARM)
		return ..()

	if(istype(I, /obj/item/tongs))
		if(I.contents.len)
			to_chat(user, span_warning("You are already holding something with [I]!"))
			return
		else
			src.forceMove(I)
			update_appearance()
			I.update_appearance()
			to_chat(user, span_notice("You grab \the [src] with \the [I]."))
			return

/obj/item/partial
	desc = "Looks like a part of something bigger."
	icon = 'dwarfs/icons/items/components.dmi'
	force = 1

/obj/item/partial/apply_material(list/_materials)
	. = ..()
	var/datum/material/M = get_material(materials)
	icon = M.apply2icon_default(icon(icon, icon_state))
	M.apply_stats(src)

/obj/item/partial/build_worn_with_material(_file, state)
	return apply_palettes(..(), list(materials))

/obj/item/partial/dagger
	name = "dagger blade"
	icon_state = "dagger_blade"
	part_name = PART_BLADE

/obj/item/partial/pickaxe
	name = "pickaxe blade"
	icon_state = "pickaxe_head"
	part_name = PART_HEAD

/obj/item/partial/shovel
	name = "shovel blade"
	icon_state = "shovel_head"
	part_name = PART_HEAD

/obj/item/partial/axe
	name = "axe blade"
	icon_state = "axe_head"
	part_name = PART_HEAD

/obj/item/partial/builder_hammer
	name = "builder's hammer head"
	icon_state = "hammer_head"
	part_name = PART_HEAD

/obj/item/partial/smithing_hammer
	name = "smithing hammer head"
	icon_state = "smithing_hammer_head"
	part_name = PART_HEAD

/obj/item/partial/zwei
	name = "zweihander blade"
	icon_state = "zweihander_blade"
	part_name = PART_BLADE

/obj/item/partial/flail
	name = "ball on a chain"
	icon_state = "cep_mace"
	part_name = PART_BLADE

/obj/item/partial/sword
	name = "sword blade"
	icon_state = "sword_blade"
	part_name = PART_BLADE

/obj/item/partial/crown_empty
	name = "empty crown"
	icon_state = "crown_part"

/obj/item/partial/scepter_part
	name = "scepter part"
	icon_state = "scepter_part"

/obj/item/partial/lantern_parts
	name = "lantern parts"
	icon_state = "lantern_parts"

/obj/item/partial/spear
	name = "spear head"
	icon_state = "spear_head"
	part_name = PART_BLADE

/obj/item/partial/halberd
	name = "halberd head"
	icon_state = "halberd_head"
	part_name = PART_BLADE

/obj/item/partial/kitchen_knife
	name = "kitchen knife blade"
	icon_state = "kitchen_knife_blade"
	part_name = PART_BLADE

/obj/item/partial/hoe
	name = "hoe head"
	icon_state = "hoe_head"
	part_name = PART_HEAD

/obj/item/partial/warhammer
	name = "warhammer head"
	icon_state = "warhammer_head"
	part_name = PART_HEAD
