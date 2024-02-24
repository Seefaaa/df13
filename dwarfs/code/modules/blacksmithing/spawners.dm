/obj/effect/spawner/smithy

/obj/effect/spawner/smithy/Initialize(mapload)
	. = ..()
	var/turf/center = get_turf(src)
	var/turf/left = locate(center.x-1, center.y, center.z)
	var/turf/right = locate(center.x+1, center.y, center.z)
	var/turf/down = locate(center.x, center.y-1, center.z)
	new /obj/structure/anvil(center)
	left.PlaceOnTop(/turf/open/lava)
	right.PlaceOnTop(/turf/open/water)
	new /obj/item/smithing_hammer(down)
	new /obj/item/tongs(down)
	new /obj/item/ingot(down)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/material_showcase/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	var/list/armor = list(
		/obj/item/clothing/suit/heavy_plate,
		/obj/item/clothing/shoes/plate_boots,
		/obj/item/clothing/under/chainmail,
		/obj/item/clothing/gloves/plate_gloves,
		/obj/item/clothing/head/heavy_plate
	)
	for(var/material_type in subtypesof(/datum/material))
		var/datum/material/M = get_material(material_type)
		if(M && M.mat == MATERIAL_METAL)
			var/turf/U = get_step(T, NORTH)
			var/turf/D = get_step(T, SOUTH)
			var/mob/living/carbon/human/dwarf = new/mob/living/carbon/human/species/dwarf(U)
			dwarf.equipOutfit(/datum/outfit)
			for(var/item_path in armor)
				var/obj/O = new item_path(T)
				O.apply_material(material_type)
				dwarf.equip_to_appropriate_slot(O)
			var/obj/I = new/obj/item/ingot(T)
			I.apply_material(material_type)
			if(M.resource)
				new M.resource(D)
			T = get_step(T, EAST)
