/obj/structure/closet/crate/wooden
	name = "wooden crate"
	desc = "Works just as well as a metal one."
	material_drop_amount = 6
	icon = 'dwarfs/icons/structures/crate.dmi'
	icon_state = "wooden"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	anchored = 1
	materials = list(PART_INGOT=/datum/material/iron, PART_PLANKS=/datum/material/wood/pine/treated)

/obj/structure/closet/crate/wooden/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/closet/crate/Initialize()
	. = ..()
	AddComponent(/datum/component/liftable, inhand_icon_state="crate")

/obj/structure/closet/crate/ComponentInitialize()
	AddComponent(/datum/component/liftable, inhand_icon_state="crate")
