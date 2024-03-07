/obj/structure/beacon
	name = "beacon"
	desc = "Highly sophisticated structure for locating the Fortress. Can have a compass calibrated to it."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "beacon"
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated)
	density = TRUE
	/// From how far can this be tracked. Depends on core grade
	var/tracking_range = 300

/obj/structure/beacon/build_material_icon(_file, state)
	return apply_palettes(..(), materials[PART_PLANKS])

/obj/structure/beacon/apply_grade(_grade)
	. = ..()
	switch(grade)
		if(1)
			tracking_range = 50
		if(2)
			tracking_range = 70
		if(3)
			tracking_range = 90
		if(4)
			tracking_range = 120
		if(5)
			tracking_range = 140
		if(6)
			tracking_range = 180

/obj/structure/beacon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/compass))
		var/obj/item/compass/compass = I
		compass.assign_core(user, src)
	else
		. = ..()
