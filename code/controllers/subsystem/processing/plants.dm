SUBSYSTEM_DEF(plants)
	name = "Plants"
	priority = FIRE_PRIORITY_PROCESS
	flags = SS_POST_FIRE_TIMING
	init_order = INIT_ORDER_PLANTS
	wait = 3 SECONDS

	var/stat_tag = "Plants" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()

	var/list/surface_plants = list()
	var/list/cave_plants = list()

/datum/controller/subsystem/plants/Initialize(start_timeofday)
	generate_plant_list()
	. = ..()

/datum/controller/subsystem/plants/stat_entry(msg)
	msg = "[stat_tag]:[length(processing)]"
	return ..()

/datum/controller/subsystem/plants/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/datum/thing = current_run[current_run.len]
		current_run.len--
		if(QDELETED(thing))
			processing -= thing
		else if(thing.process(wait * 0.1) == PROCESS_KILL)
			// fully stop so that a future START_PROCESSING will work
			STOP_PROCESSING(src, thing)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/plants/proc/generate_plant_list()
	for(var/plant_type in subtypesof(/obj/structure/plant))
		var/obj/structure/plant/plant = plant_type
		if(!initial(plant.seed_type))
			continue
		if(ispath(plant, /obj/structure/plant/tree))
			continue
		if(initial(plant.surface))
			surface_plants += plant
		else
			cave_plants += plant
