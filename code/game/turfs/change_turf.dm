// This is a list of turf types we dont want to assign to baseturfs unless through initialization or explicitly
GLOBAL_LIST_INIT(blacklisted_automated_baseturfs, typecacheof(list(
	/turf/baseturf_bottom,
	)))

/turf/proc/empty(turf_type=/turf/open, baseturf_type, list/ignore_typecache, flags)
	// Remove all atoms except observers, landmarks, docking ports
	var/static/list/ignored_atoms = typecacheof(list(/mob/dead, /obj/effect/landmark))
	var/list/allowed_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	allowed_contents -= src
	for(var/i in 1 to allowed_contents.len)
		var/thing = allowed_contents[i]
		qdel(thing, force=TRUE)

	if(turf_type)
		ChangeTurf(turf_type, baseturf_type, null, flags)

/turf/proc/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	return T

/turf/open/copyTurf(turf/T, copy_air = FALSE)
	. = ..()
	if (isopenturf(T))
		var/datum/component/wet_floor/slip = GetComponent(/datum/component/wet_floor)
		if(slip)
			var/datum/component/wet_floor/WF = T.AddComponent(/datum/component/wet_floor)
			WF.InheritComponent(slip)

//wrapper for ChangeTurf()s that you want to prevent/affect without overriding ChangeTurf() itself
/turf/proc/TerraformTurf(path, new_baseturf, flags)
	return ChangeTurf(path, new_baseturf, null, flags)

// Creates a new turf
// new_baseturfs can be either a single type or list of types, formated the same as baseturfs. see turf.dm
/turf/proc/ChangeTurf(path, list/new_baseturfs, list/new_baseturf_materials, flags, list/new_materials)
	switch(path)
		if(null)
			return
		if(/turf/baseturf_bottom)
			path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open
			if (!ispath(path))
				path = text2path(path)
				if (!ispath(path))
					warning("Z-level [z] has invalid baseturf '[SSmapping.level_trait(z, ZTRAIT_BASETURF)]'")
					path = /turf/open

	if(!GLOB.use_preloader && path == type && !(flags & CHANGETURF_FORCEOP) && (baseturfs == new_baseturfs)) // Don't no-op if the map loader requires it to be reconstructed, or if this is a new set of baseturfs
		return src
	if(flags & CHANGETURF_SKIP)
		return new path(src)

	var/old_lighting_object = lighting_object
	var/old_lighting_corner_NE = lighting_corner_NE
	var/old_lighting_corner_SE = lighting_corner_SE
	var/old_lighting_corner_SW = lighting_corner_SW
	var/old_lighting_corner_NW = lighting_corner_NW
	var/old_directional_opacity = directional_opacity
	var/old_dynamic_lumcount = dynamic_lumcount

	var/old_exl = explosion_level
	var/old_exi = explosion_id
	var/old_bp = blueprint_data
	blueprint_data = null

	var/old_type = type

	var/list/post_change_callbacks = list()
	SEND_SIGNAL(src, COMSIG_TURF_CHANGE, path, new_baseturfs, flags, post_change_callbacks)

	changing_turf = TRUE
	qdel(src)	//Just get the side effects and call Destroy

	//We do this here so anything that doesn't want to persist can clear itself
	var/list/old_comp_lookup = comp_lookup?.Copy()
	var/list/old_signal_procs = signal_procs?.Copy()
	var/turf/W = new path(src)

	// WARNING WARNING
	// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
	// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
	if(old_comp_lookup)
		LAZYOR(W.comp_lookup, old_comp_lookup)
	if(old_signal_procs)
		LAZYOR(W.signal_procs, old_signal_procs)

	for(var/datum/callback/callback as anything in post_change_callbacks)
		callback.InvokeAsync(W)

	if(new_baseturfs)
		W.baseturfs = new_baseturfs
	if(new_baseturf_materials)
		W.baseturf_materials = new_baseturf_materials

	W.explosion_id = old_exi
	W.explosion_level = old_exl

	if(!(flags & CHANGETURF_DEFER_CHANGE))
		W.AfterChange(flags, old_type)

	W.blueprint_data = old_bp

	lighting_corner_NE = old_lighting_corner_NE
	lighting_corner_SE = old_lighting_corner_SE
	lighting_corner_SW = old_lighting_corner_SW
	lighting_corner_NW = old_lighting_corner_NW

	dynamic_lumcount = old_dynamic_lumcount

	if(W.always_lit)
		W.add_overlay(GLOB.fullbright_overlay)
	else
		W.cut_overlay(GLOB.fullbright_overlay)

	if(SSlighting.initialized)
		W.lighting_object = old_lighting_object

		directional_opacity = old_directional_opacity
		recalculate_directional_opacity()

		if(lighting_object && !lighting_object.needs_update)
			lighting_object.update()

	for(var/turf/open/lava/lava_tile in RANGE_TURFS(1, src))
		lava_tile.update_lava_effect()

	var/area/thisarea = get_area(W)
	if(thisarea.lighting_effect)
		W.add_overlay(thisarea.lighting_effect)

	if(new_materials)
		W.apply_material(new_materials)

	if(flags_cavein & CAVEIN_AIR)
		for(var/direction in list(NORTH, SOUTH, EAST, WEST))
			var/turf/neighbor = get_step(src, direction)
			if(neighbor)
				QUEUE_CAVEIN(neighbor)
		var/turf/U = SSmapping.get_turf_above(src)
		if(U)
			QUEUE_CAVEIN(U)
		for(var/atom/movable/A in src)
			A.collapse()

	QUEUE_SMOOTH_NEIGHBORS(src)
	QUEUE_SMOOTH(src)

	QUEUE_SMOOTH_BORDERS(src)
	QUEUE_SMOOTH_BORDERS_NEIGHBORS(src)

	return W

/// Take off the top layer turf and replace it with the next baseturf down
/turf/proc/ScrapeAway(amount=1, flags)
	if(!amount)
		return
	var/change_type = /turf/open/openspace
	if(length(baseturfs))
		var/list/new_baseturfs = baseturfs.Copy()
		var/turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		var/list/new_materials = baseturf_materials[max(1, new_baseturfs.len - amount + 1)]
		var/list/new_baseturf_materials = baseturf_materials.Copy()
		while(ispath(turf_type, /turf/baseturf_skipover))
			amount++
			if(amount > new_baseturfs.len)
				CRASH("The bottommost baseturf of a turf is a skipover [src]([type])")
			turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
			new_materials = baseturf_materials[max(1, new_baseturfs.len - amount + 1)]
		new_baseturfs.len -= min(amount, new_baseturfs.len - 1) // No removing the very bottom
		new_baseturf_materials.len -=  min(amount, new_baseturfs.len - 1)
		if(new_baseturfs.len == 1)
			new_baseturfs = new_baseturfs[1]
			new_materials = baseturf_materials[1]
			new_baseturf_materials = baseturf_materials[1]
		return ChangeTurf(turf_type, new_baseturfs, new_baseturf_materials, flags, new_materials)

	return ChangeTurf(change_type, baseturfs, null, flags, null) // The bottom baseturf will never go away

// Make a new turf and put it on top
// The args behave identical to PlaceOnBottom except they go on top
// Things placed on top of closed turfs will ignore the topmost closed turf
// Returns the new turf
/turf/proc/PlaceOnTop(turf/change_type, flags)
	if(flags & CHANGETURF_SKIP) // We haven't been initialized
		if(flags_1 & INITIALIZED_1)
			stack_trace("CHANGETURF_SKIP was used in a PlaceOnTop call for a turf that's initialized. This is a mistake. [src]([type])")
	if(!islist(baseturfs))
		baseturfs = list(baseturfs)
	if(!islist(baseturf_materials))
		baseturf_materials = list(baseturf_materials)
	var/list/new_baseturfs = baseturfs + type
	var/list/new_baseturf_materials = baseturf_materials + list(materials)
	return ChangeTurf(change_type, new_baseturfs, new_baseturf_materials, flags, null)

// Copy an existing turf and put it on top
// Returns the new turf
/turf/proc/CopyOnTop(turf/copytarget, ignore_bottom=1, depth=INFINITY, copy_air = FALSE)
	var/list/new_baseturfs = list()
	new_baseturfs += baseturfs
	new_baseturfs += type

	if(depth)
		var/list/target_baseturfs
		if(length(copytarget.baseturfs))
			// with default inputs this would be Copy(CLAMP(2, -INFINITY, baseturfs.len))
			// Don't forget a lower index is lower in the baseturfs stack, the bottom is baseturfs[1]
			target_baseturfs = copytarget.baseturfs.Copy(clamp(1 + ignore_bottom, 1 + copytarget.baseturfs.len - depth, copytarget.baseturfs.len))
		else if(!ignore_bottom)
			target_baseturfs = list(copytarget.baseturfs)
		if(target_baseturfs)
			target_baseturfs -= new_baseturfs & GLOB.blacklisted_automated_baseturfs
			new_baseturfs += target_baseturfs

	var/turf/newT = copytarget.copyTurf(src, copy_air)
	newT.baseturfs = baseturfs_string_list(new_baseturfs, newT)
	return newT


//If you modify this function, ensure it works correctly with lateloaded map templates.
/turf/proc/AfterChange(flags, oldType) //called after a turf has been replaced in ChangeTurf()
	levelupdate()
	HandleTurfChange(src)

/turf/open/AfterChange(flags, oldType)
	..()
