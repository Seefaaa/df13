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
