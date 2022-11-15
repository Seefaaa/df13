#define TORCH_LIGHT_COLOR "#FFE0B3"

/obj/item/ingot
	name = "iron ingot"
	desc = "Can be forged into something."
	icon = 'dwarfs/icons/items/ingots.dmi'
	icon_state = "iron"
	inhand_icon_state = "iron_ingot"
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
	var/type_metal = "iron"
	var/metal_color = "#7e7e7e"

/obj/item/ingot/gold
	name = "golden ingot"
	icon_state = "gold"
	type_metal = "gold"
	metal_color = "#ffae34"
	inhand_icon_state = "gold_ingot"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'

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

/obj/item/partial/Initialize()
	. = ..()

/obj/item/partial/dagger
	name = "dagger blade"
	icon_state = "dagger_blade"

/obj/item/partial/pickaxe
	name = "pickaxe blade"
	icon_state = "pickaxe_head"

/obj/item/partial/shovel
	name = "shovel blade"
	icon_state = "shovel_head"

/obj/item/partial/axe
	name = "axe blade"
	icon_state = "axe_head"

/obj/item/partial/builder_hammer
	name = "builder's hammer head"
	icon_state = "hammer_head"

/obj/item/partial/smithing_hammer
	name = "smithing hammer head"
	icon_state = "smithing_hammer_head"

/obj/item/partial/zwei
	name = "zweihander blade"
	icon_state = "zweihander_blade"

/obj/item/partial/flail
	name = "ball on a chain"
	icon_state = "cep_mace"

/obj/item/partial/sword
	name = "sword blade"
	icon_state = "sword_blade"

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

/obj/item/partial/halberd
	name = "halberd head"
	icon_state = "halberd_head"

/obj/item/partial/kitchen_knife
	name = "kitchen knife blade"
	icon_state = "kitchen_knife_blade"

/obj/item/partial/hoe
	name = "hoe head"
	icon_state = "hoe_head"

/obj/item/partial/warhammer
	name = "warhammer head"
	icon_state = "warhammer_head"
