/obj/structure/crafter/tailor_table
	name = "tailor's table"
	desc = "A place to make clothes out of cloth and leather."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "tailor_table"
	density = TRUE
	anchored = TRUE
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)
	used_recipe_type = /datum/crafter_recipe/tailor_recipe
	craft_sound = 'dwarfs/sounds/structures/crafters/tailor.ogg'

/obj/structure/crafter/tailor_table/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/crafter/tailor_table/update_overlays()
	. = ..()
	for(var/i in 1 to contents.len)
		var/obj/O = contents[i]
		var/mutable_appearance/item = new(O)
		item.pixel_y = -16 + 16
		item.pixel_x = -16 + 17 + (i-1) * 8
		item.transform *= 0.5
		. += item
