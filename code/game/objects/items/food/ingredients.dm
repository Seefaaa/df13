/obj/item/food/slice

/obj/item/food/slice/plump_helmet
	name = "plump slice"
	desc = "Juicy slice of juicy mushroom."
	icon_state = "plump_slice"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -2
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/slice/meat
	name = "meat slice"
	desc = "Meat cutlet."
	icon_state = "meat_slice"
	mood_event_type = /datum/mood_event/ate_raw_food/meat
	mood_gain = -5
	mood_duration = 5 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=2)

/obj/item/food/slice/meat/troll
	name = "troll meat slice"
	desc = "Meat cutlet, made for a greater dishes."
	icon_state = "troll_slice"

/obj/item/food/slice/meat/chicken
	name = "chicken meat slice"
	desc = "Poultry cutlet."
	icon_state = "chicken_slice"

/obj/item/food/slice/dough
	name = "dough slice"
	desc = "Cut piece of a dough"
	icon_state = "dough_slice"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -4
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=1)

/obj/item/food/dough
	name = "dough"
	desc = "Dough for all kind of bakery."
	icon_state = "dough"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -4
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=3)

/obj/item/food/flat_dough
	name = "flat dough"
	desc = "Mama mia!"
	icon_state = "dough_flat"
	mood_event_type = /datum/mood_event/ate_raw_food/mild
	mood_gain = -4
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=3)

/obj/item/food/dough/MakeProcessable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/slice/dough, 3, 2 SECONDS)
	AddElement(/datum/element/processable, TOOL_ROLLINGPIN, /obj/item/food/flat_dough, 1, 2 SECONDS)

/obj/item/food/intestines
	name = "intestines"
	desc = "Used for sausage production."
	icon_state = "intestines"

/obj/item/food/intestines/stitched_casing
	name = "stitched casing"
	desc = "Fabricated alternative to intestines. Used for sausage production."
	icon_state = "sausage_casing"

/obj/item/food/intestines/stitched_casing/MakeEdible()
	return // not edible

/obj/item/food/intestines/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/storage/concrete/cooking/sausage)

/obj/item/food/intestines/attack_self(mob/user, modifiers)
	if(!contents.len)
		to_chat(user, span_warning("Cannot make an empty sausage!"))
		return
	to_chat(user, span_notice("You start tying up \the [src]..."))
	if(!do_after(user, 10 SECONDS, src))
		return
	var/datum/cooking_recipe/R = find_recipe(subtypesof(/datum/cooking_recipe/sausage), contents)
	var/mob/living/carbon/human/H = user
	if(!R)
		var/held_index = H.is_holding(src)
		var/obj/item/food/sausage/failed/S = new
		S.desc += "\n\The [S] contains "
		for(var/i in 1 to contents.len)
			var/obj/item/item = contents[i]
			if(i != 1)
				S.desc += ", \a [item]"
			else
				S.desc += "\a [item]"
		qdel(src)
		H.put_in_hand(S, held_index)
		user.adjust_experience(/datum/skill/cooking, 2)
		return

	var/obj/item/food/F = new R.result
	F.desc += "\n\The [F] contains "
	for(var/i in 1 to contents.len)
		var/obj/item/item = contents[i]
		if(i != 1)
			F.desc += ", \a [item]"
		else
			F.desc += "\a [item]"
	user.adjust_experience(/datum/skill/cooking, rand(5, 12))
	var/held_index = H.is_holding(src)
	qdel(src)
	H.put_in_hand(F, held_index)
	to_chat(user, span_notice("You finish tying up \the [src]..."))

/obj/item/food/sausage
	name = "sausage"
	desc = "Best served roasted."
	icon_state = "sausage"
	mood_event_type = /datum/mood_event/ate_raw_food/meat
	mood_gain = -5
	mood_duration = 5 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=5)
	var/extra_desc = "This sausage is made for beer wurst."

/obj/item/food/sausage/examine(mob/user)
	. = ..()
	var/cooking_level = user.get_skill_level(/datum/skill/cooking)
	if(cooking_level > 5)
		. += "<br>[extra_desc]"

/obj/item/food/sausage/luxurious
	food_reagents = list(/datum/reagent/consumable/nutriment=8)
	extra_desc = "This sausage is made for allwurst."

/obj/item/food/sausage/failed // bad sausage; gives poop when cooked
	food_reagents = list(/datum/reagent/consumable/nutriment=3)
	extra_desc = "This sausage is a failed sausage. It's useless."

/obj/item/food/egg
	name = "egg"
	desc = "The fruit from an industrous creature."
	food_reagents = list(/datum/reagent/consumable/nutriment=2, /datum/reagent/consumable/nutriment/protein = 1)
	icon = 'dwarfs/icons/mob/animals.dmi'
	icon_state = "egg"
	var/fertile = FALSE
	var/time_till_birth = 2 MINUTES
	var/containing_mob = /mob/living/simple_animal/chicken/baby


/obj/item/food/egg/fertile/Initialize(mapload)
	. = ..()
	fertile = TRUE
	addtimer(CALLBACK(src, PROC_REF(hatch)), time_till_birth)

/obj/item/food/egg/proc/fertelize()
	new /obj/item/food/egg/fertile(src.loc)
	qdel(src)


/obj/item/food/egg/proc/hatch()
	new containing_mob(src.loc)
	visible_message(span_notice("The [src] hatches!"))
	qdel(src)

/obj/item/food/egg/fertile
	desc = "It moves around slightly"
	mood_event_type = /datum/mood_event/ate_fertile_egg
	mood_gain = -14
	mood_duration = 5 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=2, /datum/reagent/consumable/nutriment/protein/gib = 2 )

/obj/item/food/slice/cheese
	name = "cheese slice"
	desc = "It's yellow."
	icon_state = "cheese_slice"
	mood_event_type = /datum/mood_event/ate_raw_food
	mood_gain = -1
	mood_duration = 1 MINUTES
	food_reagents = list(/datum/reagent/consumable/nutriment=2)
