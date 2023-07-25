/obj/item/food/dish
	var/plate_type

/obj/item/food/dish/on_consume(mob/living/eater, mob/living/feeder)
	. = ..()
	if(plate_type)
		var/mob/living/carbon/human/H = feeder
		var/held_index = H.is_holding(src)
		var/obj/item/I = new plate_type
		if(materials) //apply stored materials back to our place if we actually saved any
			I.apply_material(materials)
		qdel(src)
		if(held_index)
			H.put_in_hand(I, held_index)
		else
			I.forceMove(get_turf(feeder))

//**********************FIRST TIER DISHES*****************************//

/obj/item/food/dish/baked_potato
	name = "baked potato"
	desc = "Very basic meal for a quick snack."
	icon_state = "baked_potato"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=30)
	mood_event_type = /datum/mood_event/ate_meal
	mood_gain = 2

/obj/item/food/dish/cooked_egg
	name = "cooked egg"
	desc = "Tender protein ball. Perfect for a snack."
	icon_state = "cooked_egg"
	food_reagents = list(/datum/reagent/consumable/nutriment=40)
	mood_event_type = /datum/mood_event/ate_meal
	mood_gain = 1

/obj/item/food/dish/bread
	name = "bread"
	desc = "A loaf of fresh bread. Classic staple food."
	icon_state = "bread"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=40)
	mood_event_type = /datum/mood_event/ate_meal
	mood_gain = 5

/obj/item/food/dish/plump_with_steak
	name = "plump with steak"
	desc = "A simple dish containing all essential vitamins for a dwarf."
	icon_state = "plump_n_steak"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=60)
	mood_event_type = /datum/mood_event/ate_meal

/obj/item/food/dish/plump_skewer
	name = "plump skewer"
	desc = "Quick snack, not really nutritious"
	icon_state = "plump_skewer"
	plate_type = /obj/item/stick
	food_reagents = list(/datum/reagent/consumable/nutriment=55)
	mood_event_type = /datum/mood_event/ate_meal
	materials = /datum/material/wood/pine/treated

/obj/item/food/dish/meat_skewer
	name = "meat skewer"
	desc = "Quick snack, not really nutritious"
	icon_state = "meat_skewer"
	plate_type = /obj/item/stick
	food_reagents = list(/datum/reagent/consumable/nutriment=65)
	mood_event_type = /datum/mood_event/ate_meal
	materials = /datum/material/wood/pine/treated

/obj/item/food/dish/balanced_skewer
	name = "balanced skewer"
	desc = "Quick snack, not really nutritious"
	icon_state = "balanced_skewer"
	plate_type = /obj/item/stick
	food_reagents = list(/datum/reagent/consumable/nutriment=75)
	mood_event_type = /datum/mood_event/ate_meal
	materials = /datum/material/wood/pine/treated

/obj/item/food/dish/salad
	name = "salad"
	desc = "Eat your veggies, son."
	icon_state = "salad"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=60)
	mood_event_type = /datum/mood_event/ate_meal

/obj/item/food/dish/potato_salad
	name = "potato salad"
	desc = "It's  a sour snack with sweet potatoes."
	icon_state = "potato_salad"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=80)
	mood_event_type = /datum/mood_event/ate_meal

//**********************SECOND TIER DISHES*****************************//

/obj/item/food/dish/plump_stew
	name = "plump stew"
	desc = "Simple yet tasteful stew, dwarves would cook in their hold."
	icon_state = "plump_stew"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=120)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/veggie_stew
	name = "veggie stew"
	desc = "Simple yet tasteful stew, dwarves would cook in their hold."
	icon_state = "veggie_stew"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=100)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/egg_steak
	name = "fried egg with steak"
	desc = "Classic lunch meal. Desperately needs some veggies."
	icon_state = "fried_egg_steak"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=140)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/plump_pie
	name = "plump pie"
	desc = "Mushroom pie. A bit weird combination, but dwarves like it."
	icon_state = "plump_pie"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=120)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/meat_pie
	name = "meat pie"
	desc = "A pie full of juicy meat."
	icon_state = "meat_pie"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=150)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/apple_pie
	name = "meat pie"
	desc = "Sweet delicacy with a sour aftertaste."
	icon_state = "apple_pie"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=100)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/roasted_beer_wurst
	name = "roasted beer wurst"
	desc = "Ich liebe dich."
	icon_state = "beer_wurst"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=120)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/carrot_soup
	name = "carrot soup"
	desc = "Refreshing taste of carrots."
	icon_state = "carrot_soup"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=140)
	mood_event_type = /datum/mood_event/ate_meal/decent

/obj/item/food/dish/plump_soup
	name = "plump soup"
	desc = "Refreshing taste of plump helmets."
	icon_state = "plump_soup"
	plate_type = /obj/item/reagent_containers/glass/plate/bowl
	food_reagents = list(/datum/reagent/consumable/nutriment=140)
	mood_event_type = /datum/mood_event/ate_meal/decent

//**********************THIRD TIER DISHES*****************************//

/obj/item/food/dish/balanced_roll
	name = "balanced roll"
	desc = "Coming from the eastern human cities, this dish became popular among dwarves."
	icon_state = "gyros"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=240)
	mood_event_type = /datum/mood_event/ate_meal/luxurious

/obj/item/food/dish/troll_delight
	name = "troll's delight"
	desc = "Dish, for for a kings feast."
	icon_state = "troll_delight"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=240)
	mood_event_type = /datum/mood_event/ate_meal/luxurious

/obj/item/food/dish/allwurst
	name = "allwurst"
	desc = "Not sure, whos wicked brain have made this recipe, but it seems not poisonous."
	icon_state = "allwurst"
	plate_type = /obj/item/reagent_containers/glass/plate/regular
	food_reagents = list(/datum/reagent/consumable/nutriment=240)
	mood_event_type = /datum/mood_event/ate_meal/luxurious

/obj/item/food/dish/plump_quiche
	name = "plump quiche"
	desc = "A cheesy delicacy filled with sweet plumps."
	icon_state = "plump_quiche"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=260)
	mood_event_type = /datum/mood_event/ate_meal/luxurious

/obj/item/food/dish/meat_quiche
	name = "meat quiche"
	desc = "A cheesy delicacy filled with juicy meat."
	icon_state = "meat_quiche"
	plate_type = /obj/item/reagent_containers/glass/plate/flat
	food_reagents = list(/datum/reagent/consumable/nutriment=280)
	mood_event_type = /datum/mood_event/ate_meal/luxurious
