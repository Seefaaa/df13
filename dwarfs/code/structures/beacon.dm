/obj/structure/beacon
	name = "beacon"
	desc = "Highly sophisticated structure for locating the Fortress. Can have a compass calibrated to it."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "beacon"
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated)
	/// From how far can this be tracked. Depends on core grade
	var/tracking_range = 300

/obj/structure/beacon/build_material_icon(_file, state)
	return apply_palettes(..(), materials[PART_PLANKS])

/obj/structure/beacon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/compass))
		var/obj/item/compass/compass = I
		compass.assign_core(user, src)
	else
		. = ..()
