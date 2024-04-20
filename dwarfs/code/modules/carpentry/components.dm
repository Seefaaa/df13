/obj/item/weapon_hilt
	name = "weapon hilt"
	desc = "Protects you from slide cutting your hands off."
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "weapon_hilt"
	part_name = PART_HANDLE

/obj/item/weapon_hilt/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

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
	return apply_palettes(..(), materials)

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
		qdel(src)
		qdel(I)
		H.put_in_hands(T)
	else if(I.get_temperature())
		var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/stick), contents)
		var/mob/living/carbon/human/H = user
		QDEL_LAZYLIST(contents)
		update_appearance()
		var/obj/item/food/dish/F = new R.result
		F.apply_material(materials)
		user.adjust_experience(/datum/skill/cooking, R.exp_gain)
		if(R.consume_container)
			qdel(src)
		H.put_in_hands(F)
	else
		. = ..()
		update_appearance()
