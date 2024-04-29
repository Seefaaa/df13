/obj/structure/demijohn
	name = "demijohn"
	desc = "A rigid container used for fermenting."
	density = 1
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "demijohn"
	materials = list(PART_NONE=null, PART_PLANKS=/datum/material/wood/pine/treated)
	var/max_volume = 300
	var/timerid
	var/wait_before_start = 1 MINUTES // amount of time to wait before starting the work; also wait before starting to convert a converted product (juice->wine->vinegar)

/obj/structure/demijohn/Initialize()
	. = ..()
	AddComponent(/datum/component/liftable, slowdown = 5, worn_icon='dwarfs/icons/mob/inhand/righthand.dmi', inhand_icon_state="demijohn")
	create_reagents(max_volume, OPENCONTAINER)
	RegisterSignal(src, COSMIG_DEMIJOHN_STOP, PROC_REF(restart_fermentation))
	RegisterSignal(reagents, COMSIG_REAGENTS_TRANS_REAGENTS_TO, PROC_REF(handle_reagent_transfer))
	RegisterSignal(reagents, COMSIG_REAGENTS_TRANS_REAGENTS_FROM, PROC_REF(handle_reagent_transfer))

/obj/structure/demijohn/build_material_icon(_file, state)
	return apply_palettes(..(), materials[PART_PLANKS])

/obj/structure/demijohn/Destroy()
	remove_timer()
	UnregisterSignal(src, COSMIG_DEMIJOHN_STOP)
	. = ..()

/obj/structure/demijohn/proc/remove_timer()
	if(active_timers)
		deltimer(timerid)

/obj/structure/demijohn/update_overlays()
	. = ..()
	if(reagents.total_volume)
		var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/workshops.dmi', "demijohn_overlay", -FLOAT_LAYER)
		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/structure/demijohn/proc/start_fermentation()
	for(var/datum/reagent/R in reagents.reagent_list)
		SEND_SIGNAL(R, COSMIG_REAGENT_START_FERMENTING, src)

/obj/structure/demijohn/proc/stop_fermentation()
	SIGNAL_HANDLER
	remove_timer() //in case there is a timer running
	for(var/datum/reagent/R in reagents.reagent_list)
		SEND_SIGNAL(R, COSMIG_REAGENT_STOP_FERMENTING, src)

/obj/structure/demijohn/proc/restart_fermentation()
	SIGNAL_HANDLER
	stop_fermentation()
	if(reagents.total_volume)
		timerid = addtimer(CALLBACK(src, PROC_REF(start_fermentation)), wait_before_start, TIMER_STOPPABLE)

/obj/structure/demijohn/proc/handle_reagent_transfer(datum/reagents/holder, obj/target, amount, mob/transfered_by, show_message)
	SIGNAL_HANDLER
	if(transfered_by)
		restart_fermentation()
