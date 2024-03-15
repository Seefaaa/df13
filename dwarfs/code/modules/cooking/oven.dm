/obj/structure/oven
	name = "oven"
	desc = "One of essentials for delicious cuisine. Warm meal is what you need."
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "oven_empty"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	light_range = 2
	light_color = "#BB661E"
	materials = list(PART_STONE=/datum/material/stone, PART_INGOT=/datum/material/pig_iron)
	var/fuel = 0
	var/fuel_consumption = 0.5
	var/working = FALSE
	var/cooking_time = 10 SECONDS
	var/timerid
	var/obj/particle_source

/obj/structure/oven/Initialize()
	. = ..()
	particle_source = new/obj(null)
	particle_source.icon = src.icon
	particle_source.icon_state = "oven_upper"
	particle_source.vis_flags |= VIS_INHERIT_ID
	particle_source.layer = ABOVE_MOB_LAYER
	particle_source.particles = new/particles/smoke/oven
	vis_contents += particle_source
	START_PROCESSING(SSprocessing, src)
	update_appearance()
	set_light_on(working)
	update_light()

/obj/structure/oven/Destroy()
	. = ..()
	QDEL_NULL(particle_source)
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/oven/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_INGOT], materials[PART_STONE]))

/obj/structure/oven/apply_material(list/_materials)
	. = ..()
	particle_source.icon = icon

/obj/structure/oven/update_icon_state()
	. = ..()
	if(working)
		icon_state = "oven_on_lower"
	else if(fuel)
		icon_state = "oven_fueled_lower"
	else
		icon_state = "oven_empty_lower"

/obj/structure/oven/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/glass/baking_sheet) || istype(I, /obj/item/reagent_containers/glass/cake_pan))
		if(contents.len)
			to_chat(user, span_warning("There is already something cooking inside."))
			return
		I.forceMove(src)
		to_chat(user, span_notice("You place \the [I] inside [src]."))
		if(working)
			timerid = addtimer(CALLBACK(src, PROC_REF(try_cook), I, user), cooking_time, TIMER_STOPPABLE)
	else if(I.get_temperature())
		if(!fuel)
			to_chat(user, span_warning("[src] has no fuel."))
			return
		if(working)
			to_chat(user, span_warning("[src] is already lit."))
			return
		to_chat(user, span_notice("You light up [src]."))
		playsound(src, 'dwarfs/sounds/effects/ignite.ogg', 50, TRUE)
		working = TRUE
		particle_source.particles.spawning = 0.3
		set_light_on(TRUE)
		update_light()
		if(contents.len)
			timerid = addtimer(CALLBACK(src, PROC_REF(try_cook), contents[1], user), cooking_time, TIMER_STOPPABLE)
		update_appearance()
	else if(I.get_fuel())
		fuel += I.get_fuel()
		qdel(I)
		user.visible_message(span_notice("[user] throws [I] into [src]."), span_notice("You throw [I] into [src]."))
		update_appearance()

/obj/structure/oven/proc/try_cook(obj/item/I, mob/user)
	var/list/possible_recipes = list()
	if(istype(I, /obj/item/reagent_containers/glass/baking_sheet))
		possible_recipes = subtypesof(/datum/cooking_recipe/oven/sheet)
	else if(istype(I, /obj/item/reagent_containers/glass/cake_pan))
		possible_recipes = subtypesof(/datum/cooking_recipe/oven/cake)
	var/datum/cooking_recipe/R = find_recipe(possible_recipes, I.contents, I.reagents.reagent_list)
	if(!R)
		I.contents.Cut()
		I.reagents.clear_reagents()
		I.update_appearance()
		I.forceMove(get_turf(src))
		new /obj/item/food/badrecipe(get_turf(src))
		user.adjust_experience(/datum/skill/cooking, 2)
		return
	user.adjust_experience(/datum/skill/cooking, rand(10, 30))
	var/obj/O = new R.result(get_turf(src))
	O.apply_material(I.materials)
	qdel(I)

/obj/structure/oven/process(delta_time)
	if(!working)
		return
	if(prob(20))
		playsound(src, 'dwarfs/sounds/effects/fire_cracking_short.ogg', 100, TRUE)
	if(fuel<1)
		working = FALSE
		particle_source.particles.spawning = 0
		set_light_on(FALSE)
		update_light()
		update_appearance()
	fuel = max(fuel-fuel_consumption, 0)
