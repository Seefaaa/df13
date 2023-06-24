GLOBAL_VAR_INIT(fort_center, null)

/obj/effect/landmark/fort/center

/obj/effect/landmark/fort/center/Initialize()
	. = ..()
	GLOB.fort_center = src

/obj/effect/landmark/fort/center/Destroy()
	. = ..()
	if(GLOB.fort_center == src)
		GLOB.fort_center = null

/atom/movable/screen/alert/migrant
	name = "Migration sense"
	desc = "You know the fort would be this way."
	icon = 'dwarfs/icons/ui/alerts.dmi'
	icon_state = "king_sense"
	alerttooltipstyle = "dwarf"
	var/angle = 0
	var/sense_for = 3 MINUTES

/atom/movable/screen/alert/migrant/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)
	addtimer(CALLBACK(src, .proc/cleanup), sense_for)

/atom/movable/screen/alert/migrant/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/migrant/process()
	if(!owner.mind)
		return
	var/turf/P = get_turf(GLOB.fort_center)
	if(!P)
		return
	var/turf/Q = get_turf(owner)
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
	var/target_angle = get_angle(Q, P)
	var/target_dist = get_dist(P, Q)
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


/atom/movable/screen/alert/migrant/proc/cleanup()
	owner.clear_alert("migrantsense")
	qdel(src)
