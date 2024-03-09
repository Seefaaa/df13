/obj/item/compass
	name = "compass"
	desc = "A handy item for locating the fortress. Requires calibration to a magnet."
	icon = 'dwarfs/icons/items/equipment.dmi'
	icon_state = "compass"
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated)
	/// Our target structure that src will point at
	var/obj/structure/beacon/core
	/// Whether the alert is shown
	var/tracking = FALSE
	/// The mob currently using src. Needed for clean up
	var/mob/tracking_user
	/// Tracking range. Depends on grade
	var/tracking_range = 300

/obj/item/compass/build_material_icon(_file, state)
	return apply_palettes(..(), materials[PART_PLANKS])

/obj/item/compass/proc/assign_core(mob/user, obj/structure/new_core)
	var/had_core = core ? TRUE : FALSE
	if(core)
		UnregisterSignal(core, COMSIG_PARENT_QDELETING)
	if(had_core && tracking)
		if(tracking_user)
			tracking_user.clear_alert("compass")
		tracking_user = null
		tracking = FALSE
	core = new_core
	RegisterSignal(core, COMSIG_PARENT_QDELETING, PROC_REF(core_destroyed))
	to_chat(user, span_notice("You [had_core ? "re" : ""]calibrate [src] to [new_core]."))

/obj/item/compass/proc/core_destroyed()
	SIGNAL_HANDLER
	if(tracking_user)
		tracking_user.clear_alert("compass")
	core = null
	tracking = FALSE
	tracking_user = null

/obj/item/compass/attack_self(mob/user, modifiers)
	if(tracking)
		tracking = FALSE
		tracking_user = null
		user.clear_alert("compass")
	else if(core)
		tracking = TRUE
		tracking_user = user
		var/atom/movable/screen/alert/compass/A = user.throw_alert("compass", /atom/movable/screen/alert/compass)
		A.core = core
		A.compass_tracking_range = tracking_range
		A.beacon_tracking_range = core.tracking_range
	else
		to_chat(user, span_warning("\The [src] is not calibrated to any beacon!"))

/obj/item/compass/apply_grade(_grade)
	. = ..()
	switch(grade)
		if(1)
			tracking_range = 30
		if(2)
			tracking_range = 50
		if(3)
			tracking_range = 80
		if(4)
			tracking_range = 100
		if(5)
			tracking_range = 120
		if(6)
			tracking_range = 150

/atom/movable/screen/alert/compass
	name = "Compass"
	desc = "Shows the way to a calibrated beacon"
	icon = 'dwarfs/icons/ui/alerts.dmi'
	icon_state = "king_sense"
	alerttooltipstyle = "dwarf"
	var/angle = 0
	var/atom/core
	var/compass_tracking_range = 0
	var/beacon_tracking_range = 0

/atom/movable/screen/alert/compass/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/compass/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/compass/process()
	if(!owner.mind)
		return
	if(!core)
		return
	var/turf/P = get_turf(core)
	var/turf/Q = get_turf(owner)
	if(isliving(core))
		var/mob/living/real_target = core
		desc = "You are currently tracking [real_target.real_name] in [get_area_name(core)]."
	else
		desc = "You are currently tracking [core] in [get_area_name(core)]."
	/* Removing this cause imo compass shouldn't show z-level difference
	if(!P || !Q || (P.get_virtual_z_level()!= Q.get_virtual_z_level())) //The target is on a different Z level, we cannot sense that far.
		if(Q.get_virtual_z_level() - P.get_virtual_z_level() > 0)
			icon_state = "king_sense_down"
		else
			icon_state = "king_sense_up"
		var/matrix/final = matrix(transform)
		final.TurnTo(angle, 0)
		angle = 0
		animate(src, transform = final, time = 5, loop = 0)
		return
	*/
	var/target_angle = get_angle(Q, P)
	var/target_dist = get_dist(P, Q)
	if(target_dist > compass_tracking_range || target_dist > beacon_tracking_range)
		return
	cut_overlays()
	switch(target_dist)
		if(0 to 8)
			icon_state = "arrow8"
		if(9 to 15)
			icon_state = "arrow7"
		if(16 to 22)
			icon_state = "arrow6"
		if(23 to 29)
			icon_state = "arrow5"
		if(30 to 36)
			icon_state = "arrow4"
		if(37 to 43)
			icon_state = "arrow3"
		if(44 to 50)
			icon_state = "arrow2"
		if(51 to 57)
			icon_state = "arrow1"
		if(58 to 64)
			icon_state = "arrow0"
		if(65 to 400)
			icon_state = "arrow"
	var/difference = target_angle - angle
	angle = target_angle
	if(!difference)
		return
	var/matrix/final = matrix(transform)
	final.Turn(difference)
	animate(src, transform = final, time = 5, loop = 0)
