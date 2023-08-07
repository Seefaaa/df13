GLOBAL_VAR_INIT(temperature_seed, 0)
GLOBAL_VAR(surface_z)

/datum/map_generator/caves
	var/name = "Caves"

/datum/map_generator/caves/generate_turfs()
	if(CONFIG_GET(flag/disable_generation))
		return
	if(!GLOB.temperature_seed)
		GLOB.temperature_seed = rand(1, 2000)
	var/list/height_values = fbm(world.maxx, world.maxy)
	var/list/temp_values = fbm3d(world.maxx, world.maxy, area.z, GLOB.temperature_seed, frequency=0.006, lacunarity=0.4, persistence=0.4)
	for(var/y in 1 to world.maxy)
		for(var/x in 1 to world.maxx)
			var/turf/T = locate(x, y, area.z)
			if(T.loc != area)
				continue
			var/height = text2num(height_values[world.maxx * (y-1) + x])
			var/temp = text2num(temp_values[world.maxx * (y-1) + x])
			var/turf/turf_type
			switch(height)
				if(-INFINITY to -0.7)
					turf_type = /turf/open/water
				if(-0.7 to -0.45)
					turf_type = /turf/open/floor/dirt
				if(-0.45 to -0.3)
					if(temp > 0)
						turf_type = /turf/open/floor/sand
					else
						turf_type = /turf/open/floor/rock
				if(-0.3 to INFINITY)
					if(temp > 0)
						turf_type = /turf/closed/mineral/random/sand
					else
						turf_type = /turf/closed/mineral/random/stone
			T.ChangeTurf(turf_type, initial(turf_type.baseturfs))

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

/datum/map_generator/surface
	var/name = "Surface"

/datum/map_generator/surface/generate_turfs()
	if(CONFIG_GET(flag/disable_generation))
		return
	var/list/some_values = fbm(world.maxx, world.maxy)
	for(var/y in 1 to world.maxy)
		for(var/x in 1 to world.maxx)
			var/turf/T = locate(x, y, area.z)
			if(T.loc != area)
				continue
			var/value = text2num(some_values[world.maxx * (y-1) + x])
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
				if(0.4 to INFINITY)
					turf_type = /turf/closed/mineral/random/stone
			T.ChangeTurf(turf_type, initial(turf_type.baseturfs))

/datum/map_generator/surface/generate_rest()
	for(var/i in 5 to rand(5, 20)) //at least 5 forests are guaranteed
		var/x = rand(1, world.maxx)
		var/y = rand(1, world.maxy)
		var/turf/center = locate(x, y, GLOB.surface_z)
		generate_forest(center)

/datum/map_generator/surface/proc/generate_forest(turf/center)
	if((locate(/obj/structure/plant/tree) in view(40, center)))
		return
	var/center_radius = rand(10, 20)
	var/list/center_range = circlerangeturfs(center, center_radius)
	for(var/turf/T in center_range)
		if(prob(40))
			continue
		if(!T || !istype(T, /turf/open/floor/dirt) || T.is_blocked_turf() || (locate(/obj/structure/plant) in view(0, T)) || istype(T.loc, /area/fortress))
			continue
		var/tree = /obj/structure/plant/tree/pine
		if(prob(0.1))
			tree = /obj/structure/plant/tree/apple
		var/obj/structure/plant/tree/TR = new tree(T)
		TR.growthstage = rand(1, 7)
		TR.growthdelta += rand(-10 SECONDS, 1 MINUTES)
		TR.update_appearance(UPDATE_ICON)
	var/mid_radius = center_radius + rand(15, 25)
	var/list/mid_range = circlerangeturfs(center, mid_radius) - center_range
	for(var/turf/T in mid_range)
		if(prob(80))
			continue
		if(!T || !istype(T, /turf/open/floor/dirt) || T.is_blocked_turf() || (locate(/obj/structure/plant) in view(0, T)) || istype(T.loc, /area/fortress))
			continue
		var/tree = /obj/structure/plant/tree/pine
		if(prob(0.1))
			tree = /obj/structure/plant/tree/apple
		var/obj/structure/plant/tree/TR = new tree(T)
		TR.growthstage = rand(1, 7)
		TR.growthdelta += rand(-10 SECONDS, 1 MINUTES)
		TR.update_appearance(UPDATE_ICON)
	var/outer_radius = mid_radius + rand(15, 25)
	var/list/outer_range = circlerangeturfs(center, outer_radius) - center_range - mid_range
	for(var/turf/T in outer_range)
		if(prob(95))
			continue
		if(!T || !istype(T, /turf/open/floor/dirt) || T.is_blocked_turf() || (locate(/obj/structure/plant) in view(0, T)) || istype(T.loc, /area/fortress))
			continue
		var/tree = /obj/structure/plant/tree/pine
		if(prob(0.01))
			tree = /obj/structure/plant/tree/apple
		var/obj/structure/plant/tree/TR = new tree(T)
		TR.growthstage = rand(1, 7)
		TR.growthdelta += rand(-10 SECONDS, 1 MINUTES)
		TR.update_appearance(UPDATE_ICON)
