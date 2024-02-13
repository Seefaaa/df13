SUBSYSTEM_DEF(caveins)
	name = "CaveIns"
	priority = FIRE_PRIORITY_PROCESS
	flags = SS_POST_FIRE_TIMING
	init_order = INIT_ORDER_PLANTS
	wait = 1

	var/stat_tag = "CVI" //Used for logging
	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/caveins/Initialize(start_timeofday)
	. = ..()

/datum/controller/subsystem/caveins/fire(resumed)
	if (!resumed)
		currentrun = processing.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = currentrun

	while(current_run.len)
		var/turf/T = current_run[current_run.len]
		current_run.len--
		processing -= T
		T.check_stability()
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/caveins/proc/add_to_queue(turf/T)
	if(!T)
		return
	if(T.flags_cavein & CAVEIN_QUEUED)
		return
	processing += T
	T.flags_cavein |= CAVEIN_QUEUED
