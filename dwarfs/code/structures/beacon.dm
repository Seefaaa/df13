/obj/structure/beacon
	name = "beacon"
	desc = "Highly sophisticated structure for locating the Fortress. Can have a compass calibrated to it."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "beacon"
	materials = /datum/material/wood/pine/treated

/obj/structure/beacon/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/beacon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/compass))
		return
	else
		. = ..()
