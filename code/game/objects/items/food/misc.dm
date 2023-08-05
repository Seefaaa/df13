/obj/item/transfer_food
	name = "almost food"
	desc = "Almost ready to be eaten."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	init_materials = FALSE
	//Our original container we cooking this stuff in
	var/original_container
	//Container we need to transfer your stuff to
	var/required_container
	//How many times we can transfer
	var/charges = 1
	//What food do we have inside src
	var/obj/item/food_inside

/obj/item/transfer_food/pre_attack(atom/O, mob/living/user, params)
	if(required_container && istype(O, required_container))
		if(O.reagents?.total_volume || O.contents.len)
			to_chat(user, span_warning("[O] has to be empty!"))
			return
		var/atom/new_loc = O.loc
		var/obj/item/I = new food_inside
		if(O.materials)
			I.apply_material(O.materials)
		I.pixel_x = O.pixel_x
		I.pixel_y = O.pixel_y
		qdel(O)
		if(ismob(new_loc))
			var/mob/living/carbon/human/H = new_loc
			if(!H.put_in_hands(I))
				I.forceMove(get_turf(H))
		else
			I.forceMove(get_turf(new_loc))
		to_chat(user, span_notice("You transfer [initial(food_inside.name)] into [O]."))
		charges--
		if(charges)
			return
		var/mob/living/carbon/human/H = user
		var/held_index = H.is_holding(src)
		if(held_index)
			qdel(src)
			var/obj/item/C = new original_container
			H.put_in_hand(C, held_index)
		else
			new original_container(loc)
			qdel(src)
	else
		. = ..()

/obj/item/transfer_food/attack_self(mob/user, modifiers)
	if(required_container)
		return
	to_chat(user, span_notice("You take the food out of [src]."))
	for(var/i in 1 to charges)
		var/obj/item/I = new food_inside(get_turf(src))
		I.pixel_x += rand(-8, 8)
		I.pixel_y += rand(-8, 8)
	var/mob/living/carbon/human/H = user
	var/held_index = H.is_holding(src)
	if(held_index)
		qdel(src)
		var/obj/item/C = new original_container
		H.put_in_hand(C, held_index)
	else
		new original_container(loc)
		qdel(src)

/obj/item/transfer_food/examine(mob/user)
	. = ..()
	if(required_container)
		var/obj/item/I = required_container
		. += "<br>The food inside needs to be transferred to [initial(I.name)]."
	else
		. += "<br>The food inside can be taken out."

/obj/item/transfer_food/pot
	original_container = /obj/item/reagent_containers/glass/cooking_pot

/obj/item/transfer_food/pot/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/transfer_food/skillet
	original_container = /obj/item/reagent_containers/glass/pan

/obj/item/transfer_food/skillet/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_HEAD]))

/obj/item/transfer_food/cake //cake_pan
	original_container = /obj/item/reagent_containers/glass/cake_pan

/obj/item/transfer_food/cake/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/transfer_food/sheet //baking_sheet
	original_container = /obj/item/reagent_containers/glass/baking_sheet

/obj/item/transfer_food/sheet/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/transfer_food/pot/cooked_egg
	name = "cooked eggs in pot"
	icon_state = "cooking_pot_eggs"
	charges = 4
	food_inside = /obj/item/food/dish/cooked_egg

/obj/item/transfer_food/pot/plump_stew
	name = "plump stew in pot"
	icon_state = "cooking_pot_dwarven_stew"
	charges = 3
	food_inside = /obj/item/food/dish/plump_stew
	required_container = /obj/item/reagent_containers/glass/plate/bowl

/obj/item/transfer_food/pot/veggie_stew
	name = "veggie stew in pot"
	icon_state = "cooking_pot_veggie_stew"
	charges = 3
	food_inside = /obj/item/food/dish/veggie_stew
	required_container = /obj/item/reagent_containers/glass/plate/bowl

/obj/item/transfer_food/pot/potato_soup
	name = "potato soup in pot"
	icon_state = "cooking_pot_potato_soup"
	charges = 3
	food_inside = /obj/item/food/dish/potato_soup
	required_container = /obj/item/reagent_containers/glass/plate/bowl

/obj/item/transfer_food/pot/carrot_soup
	name = "carrot soup in pot"
	icon_state = "cooking_pot_carrot_soup"
	charges = 3
	food_inside = /obj/item/food/dish/carrot_soup
	required_container = /obj/item/reagent_containers/glass/plate/bowl

/obj/item/transfer_food/pot/plump_soup
	name = "plump soup in pot"
	icon_state = "cooking_pot_plump_soup"
	charges = 3
	food_inside = /obj/item/food/dish/plump_soup
	required_container = /obj/item/reagent_containers/glass/plate/bowl

/obj/item/transfer_food/skillet/beer_wurst
	name = "beer wurst in pan"
	icon_state = "skillet_beer_wurst"
	charges = 2
	food_inside = /obj/item/food/dish/roasted_beer_wurst
	required_container = /obj/item/reagent_containers/glass/plate/regular

/obj/item/transfer_food/skillet/allwurst
	name = "allwurst in pan"
	icon_state = "skillet_allwurst"
	charges = 3
	food_inside = /obj/item/food/dish/allwurst
	required_container = /obj/item/reagent_containers/glass/plate/regular

/obj/item/transfer_food/skillet/egg_steak
	name = "fried egg with steak in pan"
	icon_state = "skillet_egg_steak"
	charges = 2
	food_inside = /obj/item/food/dish/egg_steak
	required_container = /obj/item/reagent_containers/glass/plate/regular

/obj/item/transfer_food/skillet/plump_steak
	name = "plump with steak in pan"
	icon_state = "skillet_plump_steak"
	charges = 2
	food_inside = /obj/item/food/dish/plump_with_steak
	required_container = /obj/item/reagent_containers/glass/plate/regular

/obj/item/transfer_food/cake/meat_pie
	name = "meat pie in cake pan"
	icon_state = "pan_meat_pie"
	charges = 2
	food_inside = /obj/item/food/dish/meat_pie
	required_container = /obj/item/reagent_containers/glass/plate/flat

/obj/item/transfer_food/cake/apple_pie
	name = "apple pie in cake pan"
	icon_state = "pan_apple_pie"
	charges = 2
	food_inside = /obj/item/food/dish/apple_pie
	required_container = /obj/item/reagent_containers/glass/plate/flat

/obj/item/transfer_food/cake/plump_pie
	name = "plump pie in cake pan"
	icon_state = "pan_plump_pie"
	charges = 2
	food_inside = /obj/item/food/dish/plump_pie
	required_container = /obj/item/reagent_containers/glass/plate/flat

/obj/item/transfer_food/cake/plump_quiche
	name = "plump quiche in cake pan"
	icon_state = "pan_plump_quiche"
	charges = 2
	food_inside = /obj/item/food/dish/plump_quiche
	required_container = /obj/item/reagent_containers/glass/plate/flat

/obj/item/transfer_food/cake/meat_quiche
	name = "meat quiche in cake pan"
	icon_state = "pan_meat_quiche"
	charges = 2
	food_inside = /obj/item/food/dish/meat_quiche
	required_container = /obj/item/reagent_containers/glass/plate/flat

/obj/item/transfer_food/sheet/bread
	name = "bread in baking sheet"
	icon_state = "sheet_bread"
	charges = 2
	food_inside = /obj/item/food/dish/bread

/obj/item/transfer_food/sheet/roll
	name = "balanced roll in baking sheet"
	icon_state = "sheet_roll"
	charges = 2
	food_inside = /obj/item/food/dish/balanced_roll

/obj/item/transfer_food/sheet/troll_delight
	name = "troll's delight in baking sheet"
	icon_state = "sheet_trolls_delight"
	charges = 2
	food_inside = /obj/item/food/dish/troll_delight
	required_container = /obj/item/reagent_containers/glass/plate/flat

/obj/item/transfer_food/sheet/baked_potato
	name = "baked potato in baking sheet"
	icon_state = "sheet_potato"
	charges = 4
	food_inside = /obj/item/food/dish/baked_potato
