/turf/closed/mineral/stone
	baseturfs = /turf/open/floor/rock
	baseturf_materials = /datum/material/stone
	floor_type = /turf/open/floor/rock
	materials = /datum/material/stone
	var/has_troll = FALSE

/turf/closed/mineral/stone/gets_drilled(mob/user, give_exp)
	if(prob(40))
		for(var/i in 1 to rand(1, 4))
			var/obj/O = new /obj/item/stack/ore/stone(src)
			O.apply_material(materials)
	if(has_troll)
		to_chat(user, span_userdanger("THIS ROCK APPEARS TO BE ESPECIALLY SOFT!"))
		new /mob/living/simple_animal/hostile/troll(src)
	. = ..()

/turf/closed/mineral/sand
	name = "sand"
	baseturfs = /turf/open/floor/rock
	baseturf_materials = /datum/material/sandstone
	floor_type = /turf/open/floor/rock
	smooth_icon = 'dwarfs/icons/turf/walls_sandstone.dmi'
	base_icon_state = "rockwall"
	icon = 'dwarfs/icons/turf/walls_sandstone.dmi'
	icon_state = "rockwall-0"
	materials = /datum/material/sandstone

/turf/closed/mineral/sand/gets_drilled(user, give_exp)
	for(var/i in 1 to rand(1, 4))
		new /obj/item/stack/ore/stone/sand(src)
	. = ..()

/turf/closed/wall/wooden
	name = "wooden wall"
	icon = 'dwarfs/icons/turf/walls_wooden.dmi'
	base_icon_state = "wooden_wall"
	icon_state = "wooden_wall-0"
	floor_type = /turf/open/floor/wooden
	hardness = 60
	sheet_type = /obj/item/stack/sheet/planks
	materials = /datum/material/wood/pine/treated
	debris_type = /obj/structure/debris/wood/large

/turf/closed/wall/wooden/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/turf/closed/wall/stone
	name = "stone wall"
	desc = "Just a regular stone wall."
	icon = 'dwarfs/icons/turf/walls_stone.dmi'
	icon_state = "rich_wall-0"
	base_icon_state = "rich_wall"
	materials = /datum/material/stone
	sheet_type = /obj/item/stack/sheet/stone
	sheet_amount = 3
	floor_type = /turf/open/floor/tiles
	debris_type = /obj/structure/debris/brick/large

/turf/closed/wall/stone/build_material_icon(_file, state)
	return apply_palettes(..(), materials)
