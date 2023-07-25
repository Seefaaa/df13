/obj/item/transfer_food
	name = "almost food"
	desc = "Almost ready to be eaten."
	icon = 'dwarfs/icons/items/kitchen.dmi'
	//Our original container we cooking this stuff in
	var/original_container
	//Container we need to transfer your stuff to
	var/required_container
	//How many times we can transfer
	var/charges = 1
	//What food do we have inside src
	var/obj/item/food_inside

/obj/item/transfer_food/pre_attack(atom/O, mob/living/user, params)
	if(istype(O, required_container))
		if(O.reagents?.total_volume || O.contents.len)
			to_chat(user, span_warning("[O] has to be empty!"))
			return
		var/obj/item/I = new food_inside(O.loc)
		I.pixel_x = O.pixel_x
		I.pixel_y = O.pixel_y
		qdel(O)
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

/obj/item/transfer_food/examine(mob/user)
	. = ..()
	var/obj/item/I = original_container
	. += "<br>This needs to be transferred to [initial(I.name)]."

/obj/item/transfer_food/plump_stew
	name = "plump stew in pot"
	icon_state = "cooking_pot_dwarven_stew"
	charges = 3
	food_inside = /obj/item/food/dish/plump_stew
	required_container = /obj/item/reagent_containers/glass/plate/bowl
	original_container = /obj/item/reagent_containers/glass/cooking_pot

/obj/item/transfer_food/veggie_stew
	name = "veggie stew in pot"
	icon_state = "cooking_pot_veggie_stew"
	charges = 3
	food_inside = /obj/item/food/dish/veggie_stew
	required_container = /obj/item/reagent_containers/glass/plate/bowl
	original_container = /obj/item/reagent_containers/glass/cooking_pot

/obj/item/transfer_food/carrot_soup
	name = "carrot soup in pot"
	icon_state = "cooking_pot_carrot_soup"
	charges = 3
	food_inside = /obj/item/food/dish/carrot_soup
	required_container = /obj/item/reagent_containers/glass/plate/bowl
	original_container = /obj/item/reagent_containers/glass/cooking_pot

/obj/item/transfer_food/plump_soup
	name = "plump soup in pot"
	icon_state = "cooking_pot_plump_soup"
	charges = 3
	food_inside = /obj/item/food/dish/plump_soup
	required_container = /obj/item/reagent_containers/glass/plate/bowl
	original_container = /obj/item/reagent_containers/glass/cooking_pot

/obj/item/transfer_food/beer_wurst
	name = "beer wurst in pan"
	icon_state = "skillet_beer_wurst"
	charges = 2
	food_inside = /obj/item/food/dish/roasted_beer_wurst
	required_container = /obj/item/reagent_containers/glass/plate/regular
	original_container = /obj/item/reagent_containers/glass/pan

/obj/item/transfer_food/allwurst
	name = "allwurst in pan"
	icon_state = "skillet_allwurst"
	charges = 3
	food_inside = /obj/item/food/dish/allwurst
	required_container = /obj/item/reagent_containers/glass/plate/regular
	original_container = /obj/item/reagent_containers/glass/pan

/obj/item/transfer_food/egg_steak
	name = "fried egg with steak in pan"
	icon_state = "skillet_egg_steak"
	charges = 2
	food_inside = /obj/item/food/dish/egg_steak
	required_container = /obj/item/reagent_containers/glass/plate/regular
	original_container = /obj/item/reagent_containers/glass/pan
