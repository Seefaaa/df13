/obj/item/reagent_containers/glass/sack
	name = "sack"
	desc = "Storage sack, for seeds or something."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	icon_state = "bag"
	volume = 80
	allowed_reagents = list(/datum/reagent/grain, /datum/reagent/flour)
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list()

/obj/item/reagent_containers/glass/sack/examine(mob/user)
	. = ..()
	if(!reagents.total_volume)
		.+="<br>It's empty."
	else
		.+="<br>It has [reagents.get_reagent_names()] in it."

/obj/item/reagent_containers/glass/sack/update_icon(updates)
	. = ..()
	if(reagents.has_reagent_subtype(/datum/reagent/grain))
		icon_state = "bag_grain"
	else if(reagents.has_reagent_subtype(/datum/reagent/flour))
		icon_state = "bag_flour"
	else
		icon_state = "bag"

/obj/item/reagent_containers/glass/cooking_pot
	name = "cooking pot"
	desc = "A Midsummer Night's Dream of Chilli Pot"
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	inhand_icon_state = "cooking_pot"
	icon_state = "cooking_pot_open"
	amount_per_transfer_from_this = 10
	volume = 100
	materials = /datum/material/iron
	var/open = TRUE

/obj/item/reagent_containers/glass/cooking_pot/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/reagent_containers/glass/cooking_pot/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/pot)

/obj/item/reagent_containers/glass/cooking_pot/update_overlays()
	. = ..()
	if(open && reagents.total_volume)
		var/mutable_appearance/M = mutable_appearance("dwarfs/icons/items/kitchen.dmi", "cooking_pot_overlay")
		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/item/reagent_containers/glass/cooking_pot/update_icon_state()
	. = ..()
	if(open)
		icon_state = "cooking_pot_open"
	else
		icon_state = "cooking_pot_closed"

/obj/item/reagent_containers/glass/cooking_pot/update_overlays()
	. = ..()
	if(!contents.len || !open)
		return
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -16
		M.pixel_y = -16
		switch(i)
			if(1)
				M.pixel_x += 12
				M.pixel_y += 18
			if(2)
				M.pixel_x += 19
				M.pixel_y += 18
			if(3)
				M.pixel_x += 13
				M.pixel_y += 13
			if(4)
				M.pixel_x += 20
				M.pixel_y += 13
		M.transform *= 0.6
		. += M
	. += build_material_icon(initial(icon), "pot_overlay")

/obj/item/reagent_containers/glass/cooking_pot/attack_self_secondary(mob/user, modifiers)
	open = !open
	update_appearance()
	to_chat(user, span_notice("You [open?"open":"close"] [src]."))
	amount_per_transfer_from_this = open ? initial(amount_per_transfer_from_this) : 0 // cannot transfer reagents when closed

/obj/item/reagent_containers/glass/plate
	icon = 'dwarfs/icons/items/kitchen.dmi'
	volume = 20
	materials = /datum/material/wood/pine/treated

/obj/item/reagent_containers/glass/plate/Initialize(mapload, vol)
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/plate)

/obj/item/reagent_containers/glass/plate/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/reagent_containers/glass/plate/regular
	name = "plate"
	desc = "Good for holding some food inside it."
	icon_state = "wooden_plate"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list()

/obj/item/reagent_containers/glass/plate/regular/update_overlays()
	. = ..()
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -10
		M.pixel_y = -10
		switch(i)
			if(3)
				M.pixel_x += 8
				M.pixel_y += 11
				M.layer = FLOAT_LAYER-1
			if(4)
				M.pixel_x += 13
				M.pixel_y += 11
				M.layer = FLOAT_LAYER-1
			if(1)
				M.pixel_x += 8
				M.pixel_y += 8
			if(2)
				M.pixel_x += 13
				M.pixel_y += 8
		M.transform *= 0.6
		. += M

/obj/item/reagent_containers/glass/plate/flat
	name = "flat plate"
	desc = "Holds food a bit worse than a ragular plate."
	icon_state = "fancy_plate"

/obj/item/reagent_containers/glass/plate/flat/update_overlays()
	. = ..()
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -10
		M.pixel_y = -11
		switch(i)
			if(1)
				M.pixel_x += 8
				M.pixel_y += 11
			if(2)
				M.pixel_x += 13
				M.pixel_y += 11
			if(3)
				M.pixel_x += 8
				M.pixel_y += 8
			if(4)
				M.pixel_x += 13
				M.pixel_y += 8
		M.transform *= 0.6
		. += M

/obj/item/reagent_containers/glass/plate/bowl
	name = "bowl"
	desc = "Deep plate."
	icon_state = "wooden_bowl"

/obj/item/reagent_containers/glass/plate/bowl/update_overlays()
	. = ..()
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -10
		M.pixel_y = -10
		switch(i)
			if(3)
				M.pixel_x += 8
				M.pixel_y += 11
				M.layer = FLOAT_LAYER-1
			if(4)
				M.pixel_x += 13
				M.pixel_y += 11
				M.layer = FLOAT_LAYER-1
			if(1)
				M.pixel_x += 8
				M.pixel_y += 8
			if(2)
				M.pixel_x += 13
				M.pixel_y += 8
		M.transform *= 0.6
		. += M
	. += build_material_icon(icon, "wooden_bowl_overlay")

/obj/item/reagent_containers/glass/plate/bowl/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/kitchen/knife))
		var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/bowl), contents, reagents.reagent_list)
		var/mob/living/carbon/human/H = user
		if(!R)
			reagents.clear_reagents()
			contents.Cut()
			var/obj/item/food/badrecipe/S = new
			if(!H.put_in_hands(S))
				S.forceMove(get_turf(src))
			user.adjust_experience(/datum/skill/cooking, 2)
			return
		var/obj/item/food/F = new R.result
		F.apply_material(materials)
		user.adjust_experience(/datum/skill/cooking, rand(10, 30))
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			H.put_in_hand(F, held_index)
		else
			F.forceMove(loc)
			qdel(src)
	else
		. = ..()

/obj/item/reagent_containers/glass/pan
	name = "frying pan"
	desc = "Used to fry stuff."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "skillet"
	volume = 30
	materials = list(PART_HANDLE=/datum/material/wood/pine/treated, PART_HEAD=/datum/material/iron)

/obj/item/reagent_containers/glass/pan/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/reagent_containers/glass/pan/update_overlays()
	. = ..()
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -14
		M.pixel_y = -12
		switch(i)
			if(1)
				M.pixel_x += 8
				M.pixel_y += 11
			if(2)
				M.pixel_x += 13
				M.pixel_y += 11
			if(3)
				M.pixel_x += 8
				M.pixel_y += 8
			if(4)
				M.pixel_x += 13
				M.pixel_y += 8
		M.transform *= 0.6
		. += M

/obj/item/reagent_containers/glass/pan/Initialize(mapload, vol)
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/pan)

/obj/item/reagent_containers/glass/cup
	name = "cup"
	desc = "A trusty companion for a thirst-quenching break."
	icon = 'dwarfs/icons/items/containers.dmi'

/obj/item/reagent_containers/glass/cup/update_overlays()
	. = ..()
	if(reagents.total_volume)
		var/mutable_appearance/M = mutable_appearance(icon, "cup_overlay")
		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/item/reagent_containers/glass/cup/wooden
	name = "wooden cup"
	icon_state = "wooden_cup"
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)

/obj/item/reagent_containers/glass/cup/wooden/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/item/reagent_containers/glass/cup/metal
	name = "metal cup"
	icon_state = "metal_cup"
	materials = /datum/material/iron

/obj/item/reagent_containers/glass/cup/metal/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/reagent_containers/glass/cake_pan
	name = "cake pan"
	desc = "A kitchen utencil used for making cake-shaped things."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "cake_pan"
	amount_per_transfer_from_this = 10
	volume = 100
	materials = /datum/material/iron

/obj/item/reagent_containers/glass/cake_pan/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/reagent_containers/glass/cake_pan/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/pot)

/obj/item/reagent_containers/glass/cake_pan/update_overlays()
	. = ..()
	if(!contents.len)
		return
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -16
		M.pixel_y = -16
		switch(i)
			if(1)
				M.pixel_x += 16
				M.pixel_y += 21
			if(2)
				M.pixel_x += 21
				M.pixel_y += 21
			if(3)
				M.pixel_x += 15
				M.pixel_y += 17
			if(4)
				M.pixel_x += 20
				M.pixel_y += 17
		M.transform *= 0.6
		. += M
	. += build_material_icon(initial(icon), "cake_pan_overlay")

/obj/item/reagent_containers/glass/baking_sheet
	name = "baking sheet"
	desc = "It's a sheet of baking."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "sheet"
	amount_per_transfer_from_this = 10
	volume = 100
	materials = /datum/material/iron

/obj/item/reagent_containers/glass/baking_sheet/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/reagent_containers/glass/baking_sheet/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/pot)

/obj/item/reagent_containers/glass/baking_sheet/update_overlays()
	. = ..()
	if(!contents.len)
		return
	for(var/i=1;i<=min(contents.len,4);i++)
		var/obj/item/I = contents[i]
		var/mutable_appearance/M = mutable_appearance(I.icon, I.icon_state)
		M.pixel_x = -16
		M.pixel_y = -16
		switch(i)
			if(1)
				M.pixel_x += 13
				M.pixel_y += 18
			if(2)
				M.pixel_x += 19
				M.pixel_y += 18
			if(3)
				M.pixel_x += 14
				M.pixel_y += 16
			if(4)
				M.pixel_x += 20
				M.pixel_y += 16
		M.transform *= 0.6
		. += M
