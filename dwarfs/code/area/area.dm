/area/fortress
	name = "Fortress"
	icon_state = "fortress"
	static_lighting = TRUE
	base_lighting_alpha = 0

/area/fortress/surface
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/surface
	name = "surface"
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/cavesgen
	name = "Caverns"
	icon_state = "cavesgen"
	static_lighting = TRUE
	base_lighting_alpha = 0
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
