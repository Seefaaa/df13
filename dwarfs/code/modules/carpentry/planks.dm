/obj/item/stack/sheet/planks
	name = "planks"
	desc = "Used in building."
	singular_name = "Plank"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "planks"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	part_name = PART_PLANKS
	w_class = WEIGHT_CLASS_BULKY
	merge_type = /obj/item/stack/sheet/planks
	novariants = FALSE
	materials = /datum/material/wood/towercap/treated

/obj/item/stack/sheet/planks/build_material_icon(_file, state)
	return apply_palettes(..(), materials)


/obj/item/stack/sheet/planks/get_fuel()
	return 10 * amount

/obj/item/stack/sheet/bark
	name = "bark"
	desc = "Is this real?"
	singular_name = "Bark"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "bark"
	w_class = WEIGHT_CLASS_SMALL
	merge_type = /obj/item/stack/sheet/bark
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	novariants = FALSE
	materials = /datum/material/wood/towercap

/obj/item/stack/sheet/bark/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/stack/sheet/bark/get_fuel()
	return 3 * amount

/obj/structure/lattice
	name = "wooden lattice"
	desc = "Blocks you from falling down and allows building floors."
	icon = 'dwarfs/icons/structures/construction.dmi'
	icon_state = "lattice"
	anchored = 1
	obj_flags = BLOCK_Z_IN_UP | BLOCK_Z_OUT_DOWN | CAN_BE_HIT
	flags_cavein = CAVEIN_IGNORE
	materials = /datum/material/wood/pine/treated

/obj/structure/lattice/build_material_icon(_file, state)
	return apply_palettes(..(), materials)
