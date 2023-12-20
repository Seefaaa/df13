GLOBAL_VAR_INIT(temperature_seed, 0)
GLOBAL_VAR(surface_z)

/datum/map_generator/caves
	var/name = "Caves"
	keys = list("ore", "plants", "mobs", "forest", "troll_rock")
	var/list/ores = list(
		/obj/item/stack/ore/smeltable/gold = 20,
		/obj/item/stack/ore/smeltable/iron = 40,
		/obj/item/stack/ore/gem/diamond=10,
		/obj/item/stack/ore/gem/ruby=10,
		/obj/item/stack/ore/gem/sapphire=10,
		/obj/item/stack/ore/coal=40,
		/obj/item/stack/ore/smeltable/copper=30)

	var/troll_chance = list(
		1,//lobby
		2,//bottom level
		1,
		0.5,
		0.3,
		0.1,//upper level
		0,//surface
	)

/datum/map_generator/caves/generate_turfs()
	if(CONFIG_GET(flag/disable_generation))
		return
	if(!GLOB.temperature_seed)
		GLOB.temperature_seed = rand(1, 2000)
	var/list/height_values = fbm(world.maxx, world.maxy)
	var/list/temp_values = fbm3d(world.maxx, world.maxy, z, GLOB.temperature_seed, frequency=0.006, lacunarity=0.4, persistence=0.4)
	for(var/y in 1 to world.maxy)
		for(var/x in 1 to world.maxx)
			var/turf/T = locate(x, y, z)
			if(!(T.loc.type in allowed_areas))
				continue
			var/height = text2num(height_values[world.maxx * (y-1) + x])
			var/temp = text2num(temp_values[world.maxx * (y-1) + x])
			var/turf/turf_type
			switch(height)
				if(-INFINITY to -0.7)
					turf_type = /turf/open/water
				if(-0.7 to -0.45)
					turf_type = /turf/open/floor/dirt
					prob_queue(1, "mobs", list(x, y, T.z))
					prob_queue(2, "plants", list(x, y, T.z))
					prob_queue(0.5, "forest", list(x, y, T.z))
				if(-0.45 to -0.3)
					prob_queue(0.7, "mobs", list(x, y, T.z))
					if(temp > 0)
						turf_type = /turf/open/floor/sand
					else
						turf_type = /turf/open/floor/rock
				if(-0.3 to INFINITY)
					prob_queue(1, "ore", list(x, y, T.z))
					if(temp > 0)
						turf_type = /turf/closed/mineral/sand
					else
						turf_type = /turf/closed/mineral/stone
						var/chance = troll_chance[T.z]
						prob_queue(chance, "troll_rock", list(x, y, T.z))
			T.ChangeTurf(turf_type, initial(turf_type.baseturfs))

/datum/map_generator/caves/generate_rest()
	for(var/list/data in post_queue["forest"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_forest(T)

	for(var/list/data in post_queue["plants"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_wild_plants(T, SSplants.cave_plants, 3, 7)

	for(var/list/data in post_queue["mobs"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_turf_fauna(T)

	for(var/list/data in post_queue["ore"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_ore(T)

	for(var/list/data in post_queue["troll_rock"])
		var/turf/closed/mineral/stone/T = locate(data[1], data[2], data[3])
		T.has_troll = TRUE
/datum/map_generator/caves/upper
	name = "Upper Caves"
	hardness_level = 1
	ores = list(
		/obj/item/stack/ore/smeltable/iron = 30,
		/obj/item/stack/ore/coal=40,
		/obj/item/stack/ore/smeltable/copper=30)

/datum/map_generator/caves/middle
	name = "Middle Caves"
	hardness_level = 2
	ores = list(
		/obj/item/stack/ore/smeltable/gold = 40,
		/obj/item/stack/ore/smeltable/iron = 40,
		/obj/item/stack/ore/gem/diamond=5,
		/obj/item/stack/ore/gem/ruby=5,
		/obj/item/stack/ore/gem/sapphire=5,
		/obj/item/stack/ore/coal=20,
		/obj/item/stack/ore/smeltable/copper=20)

/datum/map_generator/caves/bottom
	name = "Bottom Caves"
	hardness_level = 3
	ores = list(
		/obj/item/stack/ore/smeltable/gold = 20,
		/obj/item/stack/ore/gem/diamond=20,
		/obj/item/stack/ore/gem/ruby=20,
		/obj/item/stack/ore/gem/sapphire=20)

/datum/map_generator/surface
	var/name = "Surface"
	keys = list("plants", "mobs", "forest")

/datum/map_generator/surface/generate_turfs()
	if(CONFIG_GET(flag/disable_generation))
		return
	var/list/some_values = fbm(world.maxx, world.maxy)
	for(var/y in 1 to world.maxy)
		for(var/x in 1 to world.maxx)
			var/turf/T = locate(x, y, z)
			if(!(T.loc.type in allowed_areas))
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
					prob_queue(0.1, "mobs", list(x, y, T.z))
					prob_queue(0.3, "plants", list(x, y, T.z))
				if(-0.3 to 0.4)
					turf_type = /turf/open/floor/dirt/grass
					prob_queue(0.1, "mobs", list(x, y, T.z))
					prob_queue(0.5, "plants", list(x, y, T.z))
					prob_queue(0.5, "forest", list(x, y, T.z))
				if(0.4 to INFINITY)
					turf_type = /turf/closed/mineral/stone
			T.ChangeTurf(turf_type, initial(turf_type.baseturfs))

/datum/map_generator/surface/generate_rest()
	for(var/list/data in post_queue["forest"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_forest(T)

	for(var/list/data in post_queue["plants"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_wild_plants(T, SSplants.surface_plants, 3, 7)

	for(var/list/data in post_queue["mobs"])
		var/turf/T = locate(data[1], data[2], data[3])
		generate_turf_fauna(T)

/datum/map_generator/proc/generate_wild_plants(turf/center, list/plant_types, min_plants=1, max_plants=5)
	var/plant_type = pick(plant_types)
	for(var/i in 1 to rand(min_plants, max_plants))
		var/turf/T = locate(center.x + rand(-3, 3), center.y + rand(-3, 3), z)
		if(!istype(T, /turf/open/floor/dirt))
			continue
		if(is_blocked_turf(T))
			continue
		var/obj/structure/plant/plant = new plant_type(T)
		plant.growthstage = rand(0, plant.growthstages)
		plant.lifespan = INFINITY
		plant.growthdelta += rand(-plant.growthdelta*0.2, plant.growthdelta*0.6)
		plant.update_appearance(UPDATE_ICON)

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

/datum/map_generator/caves/proc/generate_forest(turf/center)
	if((locate(/obj/structure/plant/tree) in view(30, center)))
		return
	var/center_radius = rand(5, 20)
	var/list/center_range = circlerangeturfs(center, center_radius)
	for(var/turf/T in center_range)
		if(prob(70))
			continue
		if(!T || !istype(T, /turf/open/floor/dirt) || T.is_blocked_turf() || (locate(/obj/structure/plant) in view(0, T)) || istype(T.loc, /area/fortress))
			continue
		var/obj/structure/plant/tree/TR = new /obj/structure/plant/tree/towercap(T)
		TR.growthstage = rand(1, 7)
		TR.growthdelta += rand(-10 SECONDS, 1 MINUTES)
		TR.update_appearance(UPDATE_ICON)
	var/mid_radius = center_radius + rand(10, 20)
	var/list/mid_range = circlerangeturfs(center, mid_radius) - center_range
	for(var/turf/T in mid_range)
		if(prob(90))
			continue
		if(!T || !istype(T, /turf/open/floor/dirt) || T.is_blocked_turf() || (locate(/obj/structure/plant) in view(0, T)) || istype(T.loc, /area/fortress))
			continue
		var/obj/structure/plant/tree/TR = new /obj/structure/plant/tree/towercap(T)
		TR.growthstage = rand(1, 7)
		TR.growthdelta += rand(-10 SECONDS, 1 MINUTES)
		TR.update_appearance(UPDATE_ICON)

/datum/map_generator/surface/generate_turf_fauna(turf/center)
	var/list/possible_animals = list(
		/mob/living/simple_animal/chicken=60,
		/mob/living/simple_animal/goat=40,
		/mob/living/simple_animal/hostile/bear=20
	)
	var/animal_type = pickweight(possible_animals)
	//hostile mobs spawn alone; other mobs can spawn in a group
	var/max_amount = ispath(animal_type, /mob/living/simple_animal/hostile) ? 1 : 3
	for(var/i in 1 to rand(1, max_amount))
		var/turf/T = locate(center.x + rand(-3, 3), center.y + rand(-3, 3), z)
		if(!isopenturf(T) || T.is_blocked_turf())
			continue
		new animal_type(T)

/datum/map_generator/caves/generate_turf_fauna(turf/center)
	var/list/possible_animals = list(
		/mob/living/simple_animal/hostile/giant_spider=20,
		/mob/living/simple_animal/hostile/troll=50
	)
	var/animal_type = pickweight(possible_animals)
	//hostile mobs spawn alone; other mobs can spawn in a group
	var/max_amount = ispath(animal_type, /mob/living/simple_animal/hostile) ? 1 : 3
	//we don't want hostile animals too close to each other
	if((locate(/mob/living/simple_animal/hostile) in range(25, center)))
		return
	for(var/i in 1 to rand(1, max_amount))
		var/turf/T = locate(center.x + rand(-3, 3), center.y + rand(-3, 3), z)
		if(!isopenturf(T) || T.is_blocked_turf())
			continue
		new animal_type(T)

/datum/map_generator/caves/proc/generate_ore(turf/closed/mineral/center)
	var/obj/item/stack/ore/O = pickweight(ores)
	var/vein_type = initial(O.vein_type)
	if(!vein_type)
		center.mineralType = O
		center.mineralAmt = rand(1, 5)
	else
		var/datum/vein/V = new vein_type(center)
		V.generate(O)
		qdel(V)
