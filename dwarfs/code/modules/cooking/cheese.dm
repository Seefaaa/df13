/obj/item/cheese
	name = "cheese"
	desc = "Fresh cheese wheel ready to age into a masterpiece dairy product."
	icon = 'dwarfs/icons/items/food.dmi'
	icon_state = "cheese_young"
	var/aged = FALSE

/obj/item/cheese/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(age)), 5 MINUTES)

/obj/item/cheese/proc/age()
	if(QDELETED(src))
		return
	// if aged via proccall etc..
	if(aged)
		return
	desc = "Aged cheese wheel bursting with flavor."
	icon_state = "cheese"
	aged = TRUE
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/slice/cheese, 6, 2 SECONDS)
