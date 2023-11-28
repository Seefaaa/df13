/obj/item/ingot
	name = "ingot"
	desc = "Can be forged into something."
	icon = 'dwarfs/icons/items/ingots.dmi'
	icon_state = "ingot"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = IGNORES_GRADES
	force = 2
	throwforce = 5
	throw_range = 7
	materials = /datum/material/iron
	part_name = PART_INGOT
	var/datum/smithing_recipe/recipe = null
	var/durability = 6
	var/progress_current = 0
	var/progress_need = 10
	var/heattemp = 0
	materials = /datum/material/iron

/obj/item/ingot/apply_material(list/_materials)
	. = ..()
	var/datum/material/M = get_material(materials)
	name = "[M.name] ingot"

/obj/item/ingot/update_stats(_grade, use_grade)
	. = ..()
	name = "[get_material_name(materials)] ingot"

/obj/item/ingot/build_material_icon(_file, state)
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
	var/mutable_appearance/heat = mutable_appearance('dwarfs/icons/items/ingots.dmi', "ingot_heat")
	heat.color = "#ff9900"
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
