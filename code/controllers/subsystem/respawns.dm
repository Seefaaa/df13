SUBSYSTEM_DEF(respawns)
	name = "Respawns"
	flags = SS_NO_FIRE

	///A list of keys and their next allowed respawn times. We are storing this here and not on client since clients can reset their timer by reconnecting
	var/list/next_respawn = list()
	///Respawn cooldown for clients
	var/respawn_cooldown = 5 MINUTES
	///A list of keys and their last mob names to prevent them joining as the same character
	var/list/characters = list()

/datum/controller/subsystem/respawns/Initialize(start_timeofday)
	if(CONFIG_GET(number/respawn_cooldown))
		respawn_cooldown = CONFIG_GET(number/respawn_cooldown)
	generate_landmarks()
	. = ..()

/datum/controller/subsystem/respawns/proc/generate_landmarks()
	var/attempts = 0
	var/x
	var/y
	var/z = GLOB.surface_z
	while(LAZYLEN(GLOB.start_landmarks_map_edge) < 15)
		attempts++
		if(prob(50))//spawn on top/bottom
			x = rand(10, world.maxx-10)
			y = pick(10, world.maxy-10)
		else//spawn on left/right side
			y = rand(10, world.maxx-10)
			x = pick(10, world.maxy-10)
		var/turf/T = locate(x, y, z)
		if(attempts > 100)//fuck it, we NUKE shit to make place
			nuke_area(T)
			new/obj/effect/landmark/start/map_edge(T)
			continue
		if(isclosedturf(T) || T.is_blocked_turf())
			continue
		if((locate(/obj/structure/plant/tree) in range(10, T)))
			continue
		new/obj/effect/landmark/start/map_edge(T)

/datum/controller/subsystem/respawns/proc/nuke_area(turf/center)
	for(var/turf/closed/C in range(10, center))
		if(istype(C, /turf/closed/indestructible))
			continue
		C.ChangeTurf(/turf/open/floor/dirt/grass)
	for(var/obj/structure/plant/tree/tree in range(10, center))
		qdel(tree)

/datum/controller/subsystem/respawns/proc/can_respawn(mob/user)
	if(!user.key)
		return FALSE
	return world.time > next_respawn[user.key]

/datum/controller/subsystem/respawns/proc/mob_died(mob/user)
	if(!user.key)
		return
	next_respawn[user.key] = world.time + respawn_cooldown

/datum/controller/subsystem/respawns/proc/character_spawned(mob/user, character_name)
	if(!user.key)
		return
	characters[user.key] = character_name

/datum/controller/subsystem/respawns/proc/can_spawn_character(mob/user, character_name)
	if(!user.key)
		return FALSE
	return character_name != characters[user.key]

/datum/controller/subsystem/respawns/proc/respawn_time(mob/user)
	return next_respawn[user.key] - world.time //used only if world.time < respawn_time
