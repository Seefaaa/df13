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
	. = ..()

/datum/controller/subsystem/respawns/proc/can_respawn(mob/user)
	if(!user.key)
		return FALSE
	return world.time > next_respawn[user.key]

/datum/controller/subsystem/respawns/proc/mob_respawned(mob/user)
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
