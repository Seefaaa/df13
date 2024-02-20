/obj/structure/crafter/workbench
	name = "workbench"
	desc = "A place to assemble all your wonderful creations."
	icon = 'dwarfs/icons/structures/64x32.dmi'
	icon_state = "workshop"
	density = TRUE
	anchored = TRUE
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)
	used_recipe_type = /datum/crafter_recipe/workbench_recipe
	craft_sound = 'dwarfs/sounds/structures/crafters/workbench.ogg'

/obj/structure/crafter/workbench/Initialize()
	. = ..()
	var/turf/T = locate(x+1,y,z)
	if(T)
		T.density = TRUE

/obj/structure/crafter/workbench/Destroy()
	var/turf/T = locate(x+1,y,z)
	if(istype(T, /turf/open))
		T.density = FALSE
	. = ..()

/obj/structure/crafter/workbench/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/crafter/workbench/update_overlays()
	. = ..()
	for(var/i in 1 to contents.len)
		var/obj/O = contents[i]
		var/mutable_appearance/item = new(O)
		item.pixel_y = -16 + 17
		item.pixel_x = -16 + 18 + (i-1) * 8
		item.transform *= 0.7
		. += item
