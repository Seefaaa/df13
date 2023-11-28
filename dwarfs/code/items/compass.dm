/obj/item/compass
	name = "compass"
	desc = "A handy item for locating the fortress. Requires calibration to a magnet."
	icon = 'dwarfs/icons/items/equipment.dmi'
	icon_state = "compass"
	materials = /datum/material/wood/pine/treated
	/// Our target structure that src will point at
	var/obj/core

/obj/item/compass/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/compass/attack_self(mob/user, modifiers)
	. = ..()
