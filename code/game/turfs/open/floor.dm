/turf/open/floor
	//NOTE: Floor code has been refactored, many procs were removed and refactored
	//- you should use istype() if you want to find out whether a floor has a certain type
	//- floor_tile is now a path, and not a tile obj
	name = "floor"
	desc = "This is a floor."
	icon = 'dwarfs/icons/turf/floors.dmi'
	base_icon_state = "floor"
	baseturfs = /turf/open/openspace

	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	flags_1 = NO_SCREENTIPS_1
	turf_flags = CAN_BE_DIRTY_1
	smoothing_flags = SMOOTH_BORDERS
	smoothing_groups = list(SMOOTH_GROUP_TURF_OPEN, SMOOTH_GROUP_OPEN_FLOOR)
	intact = TRUE
	tiled_dirt = TRUE

	/// a list of tool behaviors and respective time how long will it take to mine src with said tool
	var/list/digging_tools = null

	var/broken = FALSE
	var/burnt = FALSE
	var/list/broken_states
	var/list/burnt_states


/turf/open/floor/Initialize(mapload)
	. = ..()
	if (broken_states)
		stack_trace("broken_states defined at the object level for [type], move it to setup_broken_states()")
	else
		var/list/new_broken_states = setup_broken_states()
		if(new_broken_states)
			broken_states = new_broken_states
	if (burnt_states)
		stack_trace("burnt_states defined at the object level for [type], move it to setup_burnt_states()")
	else
		var/list/new_burnt_states = setup_burnt_states()
		if(new_burnt_states)
			burnt_states = string_list(new_burnt_states)
	if(!broken && broken_states && (icon_state in broken_states))
		broken = TRUE
	if(!burnt && burnt_states && (icon_state in burnt_states))
		burnt = TRUE


/turf/open/floor/proc/setup_broken_states()
	return

/turf/open/floor/proc/setup_burnt_states()
	return

/turf/open/floor/proc/try_digdown(obj/item/I, mob/user)
	var/dig_time = digging_tools[I.tool_behaviour]
	to_chat(user, span_notice("You start digging [src]..."))
	if(I.use_tool(src, user, dig_time, volume=50))
		digdown(user)

/turf/open/floor/proc/digdown(mob/user)
	var/turf/TD = SSmapping.get_turf_below(src)
	if(TD)
		if(isclosedturf(TD))
			var/turf/closed/TC = TD
			if(TC.floor_type == type)
				TC.ScrapeAway()
			else if(baseturfs.len < 2 || !(TC.floor_type in baseturfs))
				baseturfs.Insert(2, TC.floor_type)
				baseturf_materials.Insert(2, TC.materials)
		var/turf/newturf = ScrapeAway()
		if(isopenspace(newturf))
			user.visible_message(span_notice("[user] digs out a hole in the ground."), span_notice("You dig out a hole in the ground."))
	else
		to_chat(user, span_warning("Something very dense underneath!"))
		//TODO: make something bad happen!(clowns)

/turf/open/floor/ex_act(severity, target)
	var/shielded = is_shielded()
	..()
	if(severity != 1 && shielded && target != src)
		return
	if(target == src)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return
	if(target != null)
		severity = 3

	switch(severity)
		if(1)
			ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
		if(2)
			switch(pick(1,2;75,3))
				if(1)
					if(!length(baseturfs) || !ispath(baseturfs[baseturfs.len-1], /turf/open/floor))
						ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
					else
						ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
				if(2)
					ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
				if(3)
					if(prob(80))
						ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
					else
						break_tile()
		if(3)
			if (prob(50))
				src.break_tile()

/turf/open/floor/is_shielded()
	for(var/obj/structure/A in contents)
		return 1

/turf/open/floor/attack_paw(mob/user)
	return attack_hand(user)

/turf/open/floor/proc/break_tile_to_plating()
	var/turf/open/floor/T = make_plating()
	if(!istype(T))
		return
	T.break_tile()

/turf/open/floor/proc/break_tile()
	if(broken)
		return
	if(broken_states)
		icon_state = pick(broken_states)
	broken = 1

/turf/open/floor/burn_tile()
	if(broken || burnt)
		return
	if(LAZYLEN(burnt_states))
		icon_state = pick(burnt_states)
	else
		icon_state = pick(broken_states)
	burnt = 1

/turf/open/floor/proc/make_plating(force = FALSE)
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

///For when the floor is placed under heavy load. Calls break_tile(), but exists to be overridden by floor types that should resist crushing force.
/turf/open/floor/proc/crush()
	break_tile()

/turf/open/floor/ChangeTurf(path, list/new_baseturfs, list/new_baseturf_materials, flags, list/new_materials)
	if(!isfloorturf(src))
		return ..() //fucking turfs switch the fucking src of the fucking running procs
	if(!ispath(path, /turf/open/floor))
		return ..()
	var/old_dir = dir
	var/turf/open/floor/W = ..()
	W?.setDir(old_dir)
	W?.update_icon()
	return W

/turf/open/floor/AfterChange(flags, oldType)
	. = ..()
	var/turf/closed/TD = SSmapping.get_turf_below(src)
	if(isclosedturf(TD) && TD.floor_type)
		apply_material(TD.materials)
	var/obj/L = (locate(/obj/structure/lattice) in src)
	if(L)
		qdel(L)

/turf/open/floor/attackby(obj/item/I, mob/user, params)
	if(!I || !user)
		return TRUE
	. = ..()
	if(.)
		return .

	if(digging_tools && (I.tool_behaviour in digging_tools))
		try_digdown(I, user)
		return
	if(user.a_intent == INTENT_HARM && istype(I, /obj/item/stack/sheet))
		var/obj/item/stack/sheet/sheets = I
		return sheets.on_attack_floor(user, params)
	if(I.tool_behaviour == TOOL_BUILDER_HAMMER)
		var/obj/item/builder_hammer/H = I
		if(!H.selected_blueprint)
			to_chat(user, span_warning("[H] doesn't have a blueprint selected!"))
			return
		var/obj/structure/blueprint/B = new H.selected_blueprint
		var/target_structure = B.target_structure
		var/list/dimensions = B.dimensions
		qdel(B)
		if(!ispath(target_structure, /turf/open))
			var/list/turfs = RECT_TURFS(dimensions[1], dimensions[2], src)
			for(var/turf/T in turfs)
				if(T.is_blocked_turf())
					to_chat(user, span_warning("You have to free the space required to place the blueprint first!"))
					return
		var/obj/structure/blueprint/new_blueprint = new H.selected_blueprint(src)
		new_blueprint.dir = user.dir
		new_blueprint.update_appearance()
	else if(istype(I, /obj/item/sapling))
		var/obj/item/offhand = user.get_inactive_held_item()
		if(!offhand || offhand?.tool_behaviour != TOOL_SHOVEL)
			to_chat(user, span_warning("You need a shovel to plant [I]!"))
			return
		if(is_blocked_turf())
			to_chat(user, span_warning("\The [src] is already occupied!"))
			return
		var/obj/item/sapling/S = I
		var/obj/structure/plant/P = new S.plant_type(src)
		P.health = S.health
		P.growthstage = S.growthstage
		P.update_appearance()
		to_chat(user, span_notice("You plant [S]."))
		qdel(S)
		user.adjust_experience(/datum/skill/farming, rand(1,7))
	return FALSE

/turf/open/floor/crowbar_act(mob/living/user, obj/item/I)
	if(do_after(user, I.toolspeed * 0.5 SECONDS, src))
		if(intact && pry_tile(I, user))
			return TRUE

/turf/open/floor/proc/pry_tile(obj/item/I, mob/user, silent = FALSE)
	I.play_tool_sound(src, 80)
	return remove_tile(user, silent)

/turf/open/floor/proc/remove_tile(mob/user, silent = FALSE, force_plating)
	if(broken || burnt)
		broken = FALSE
		burnt = FALSE
		if(user && !silent)
			to_chat(user, span_notice("You remove the damaged tile."))
	else
		if(user && !silent)
			to_chat(user, span_notice("You remove the tile."))
	return make_plating(force_plating)

/turf/open/floor/acid_melt()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
