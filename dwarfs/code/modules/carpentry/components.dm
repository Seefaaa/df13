/obj/item/weapon_hilt
	name = "weapon hilt"
	desc = "Protects you from slide cutting your hands off."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "weapon_hilt"
	part_name = PART_HANDLE

/obj/item/weapon_hilt/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials))


/obj/item/weapon_hilt/get_fuel()
	return 3

/obj/item/stick
	name = "stick"
	desc = "Stick. That's just stick."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "stick"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	part_name = PART_HANDLE

/obj/item/stick/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials))

/obj/item/stick/get_fuel()
	return 5

/obj/item/stick/Initialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/stick)

/obj/item/stick/update_overlays()
	. = ..()
	for(var/i=1;i<=contents.len;i++)
		var/obj/item/item = contents[i]
		var/mutable_appearance/M = mutable_appearance(item.icon, item.icon_state)
		M.pixel_x = (12 + 3*(i-1))-16
		M.pixel_y = (12 + 3*(i-1))-16
		M.transform = turn(M.transform, 360*sin(i*30))
		M.transform *= 0.6
		.+=M

/obj/item/stick/attackby(obj/item/I, mob/user, params)
	if(isgrowable(I))
		var/obj/item/growable/G = I
		if(!(G.food_flags & GRAIN))
			return
		var/mob/living/carbon/human/H = user
		var/obj/item/flashlight/fueled/torch/T = new()
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			H.put_in_hand(T, held_index)
		else
			T.forceMove(loc)
			qdel(src)
		qdel(I)
	else if(I.get_temperature())
		var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/stick), contents)
		var/mob/living/carbon/human/H = user
		if(!R)
			contents.Cut()
			update_appearance()
			var/obj/item/food/badrecipe/S = new
			if(!H.put_in_hands(S))
				S.forceMove(get_turf(src))
			user.adjust_experience(/datum/skill/cooking, 2)
			return

		var/obj/item/food/dish/F = new R.result
		F.apply_material(materials)
		user.adjust_experience(/datum/skill/cooking, rand(5, 15))
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			H.put_in_hand(F, held_index)
		else
			F.forceMove(loc)
			qdel(src)
	else
		. = ..()
		update_appearance()
