GLOBAL_VAR_INIT(temperature_seed, 0)
GLOBAL_VAR(surface_z)

/datum/map_generator/caves
	var/name = "Caves"

/datum/map_generator/caves/generate_terrain(list/turfs)
	if(CONFIG_GET(flag/disable_generation))
		return
	if(!GLOB.temperature_seed)
		GLOB.temperature_seed = rand(1, 2000)
	var/start_time = REALTIMEOFDAY
	var/list/height_values = fbm(world.maxx, world.maxy)
	var/turf/first_turf = turfs[1]
	var/list/temp_values = fbm3d(world.maxx, world.maxy, first_turf.z, GLOB.temperature_seed, frequency=0.006, lacunarity=0.4, persistence=0.4)
	for(var/turf/T in turfs)
		var/height = text2num(height_values[world.maxx * (T.y - 2) + T.x])
		var/temp = text2num(temp_values[world.maxx * (T.y - 2) + T.x])
		var/turf/turf_type
		switch(height)
			if(-INFINITY to -0.7)
				turf_type = /turf/open/water
			if(-0.7 to -0.45)
				turf_type = /turf/open/floor/dirt
				generate_turf_flora(T, 8)
			if(-0.45 to -0.3)
				if(temp > 0)
					turf_type = /turf/open/floor/sand
				else
					turf_type = /turf/open/floor/rock
					generate_turf_flora(T, 1)
			if(-0.3 to INFINITY)
				if(temp > 0)
					turf_type = /turf/closed/mineral/random/sand
				else
					turf_type = /turf/closed/mineral/random/dwarf_lustress
		T.ChangeTurf(turf_type, initial(turf_type.baseturfs))
	to_chat(world, span_green(" -- #<b>[name]</b>:> <b>[(REALTIMEOFDAY - start_time)/10]s</b> -- "))
	log_world("[name] is done job for [(REALTIMEOFDAY - start_time)/10]s!")

/datum/map_generator/caves/generate_turf_flora(turf, chance)
	if(prob(chance))
		var/obj/structure/plant/tree/towercap/temp = new (turf)
		temp.growthstage = rand(0, 7)
		temp.growthdelta = rand(80, 400) SECONDS
		temp.update_appearance()

/datum/map_generator/caves/upper
	name = "Upper Caves"

/datum/map_generator/caves/middle
	name = "Middle Caves"

/datum/map_generator/caves/bottom
	name = "Bottom Caves"

/area/cavesgen
	name = "Caverns"
	icon_state = "cavesgen"
	static_lighting = TRUE
	base_lighting_alpha = 0
	area_flags = CAVES_ALLOWED | FLORA_ALLOWED | MOB_SPAWN_ALLOWED
	sound_environment = SOUND_ENVIRONMENT_CAVE
	ambientsounds = list('sound/ambience/caves8.ogg', 'sound/ambience/caves_old.ogg')
	map_generator = /datum/map_generator/caves

/area/cavesgen/upper_level
	map_generator = /datum/map_generator/caves/upper

/area/cavesgen/middle_level
	map_generator = /datum/map_generator/caves/middle

/area/cavesgen/bottom_level
	map_generator = /datum/map_generator/caves/bottom

/area/surface
	name = "surface"
	static_lighting = FALSE
	base_lighting_alpha = 255
	map_generator = /datum/map_generator/surface
	ambientsounds = GENERIC_AMBIGEN

/area/surface/Initialize(mapload)
	. = ..()
	GLOB.surface_z = z

/datum/map_generator/surface
	var/name = "Surface"

/datum/map_generator/surface/generate_terrain(list/turfs)
	if(CONFIG_GET(flag/disable_generation))
		return
	var/start_time = REALTIMEOFDAY
	var/list/some_values = fbm(world.maxx, world.maxy)
	for(var/turf/T in turfs)
		var/value = text2num(some_values[world.maxx * (T.y-2) + T.x])
		var/turf/turf_type
		switch(value)
			if(-INFINITY to -0.6)
				turf_type = /turf/open/water
			if(-0.6 to -0.45)
				turf_type = /turf/open/floor/sand
			if(-0.45 to -0.3)
				turf_type = /turf/open/floor/dirt
			if(-0.3 to 0.4)
				turf_type = /turf/open/floor/dirt/grass
				if(prob(0.05))
					new /mob/living/simple_animal/goat(T)
			if(0.4 to INFINITY)
				turf_type = /turf/closed/mineral/random/dwarf_lustress
		T.ChangeTurf(turf_type, initial(turf_type.baseturfs))
	to_chat(world, span_green(" -- #<b>[name]</b>:> <b>[(REALTIMEOFDAY - start_time)/10]s</b> -- "))
	log_world("[name] is done job for [(REALTIMEOFDAY - start_time)/10]s!")
