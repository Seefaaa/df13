// This is not obtainable in the game yet, since it has no use
/obj/structure/crafter/stonecutter_table
	name = "stonecutter's table"
	desc = "A place to make all your stone wonders."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "stonecutter_table"
	density = TRUE
	anchored = TRUE
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)
	craft_sound = 'dwarfs/sounds/structures/crafters/mason.ogg'

/obj/structure/crafter/stonecutter_table/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/crafter/stonecutter_table/update_overlays()
	. = ..()
	for(var/i in 1 to contents.len)
		var/obj/O = contents[i]
		var/mutable_appearance/item = new(O)
		item.pixel_y = -16 + 21
		item.pixel_x = -16 + 5 + (i-1) * 8
		item.transform *= 0.7
		. += item
