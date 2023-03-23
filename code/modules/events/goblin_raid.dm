/datum/round_event_control/goblin_raid
	name = "Goblin Raid"
	typepath = /datum/round_event/ghost_role/goblin_raid
	weight = 5
	max_occurrences = INFINITY
	min_players = 10

/datum/round_event/ghost_role/goblin_raid
	announceChance = 0
	minimum_required = 1
	role_name = "goblin raider"
	var/spawns = 2

/datum/round_event/ghost_role/goblin_raid/pre_start()
	spawns = 2 + round(GLOB.mob_living_list.len / 10)

/datum/round_event/ghost_role/goblin_raid/spawn_role()
	var/list/candidates = get_candidates("Goblin", null, FALSE)
	if(!candidates.len)
		return NOT_ENOUGH_PLAYERS
	var/x
	var/y
	var/z = GLOB.surface_z
	if(prob(50))//spawn on top/bottom
		x = rand(10, world.maxx-10)
		y = pick(10, world.maxy-10)
	else//spawn on left/right side
		y = rand(10, world.maxx-10)
		x = pick(10, world.maxy-10)

	while(spawns > 1 && candidates.len > 1)
		var/client/C = pick_n_take(candidates)
		var/mob/living/carbon/human/species/goblin/warrior = new(locate(x+rand(-5,5), y+rand(-5,5), z))
		warrior.equipOutfit(/datum/outfit/goblin)
		warrior.key = C.key
		spawned_mobs += warrior
		to_chat(warrior, span_announce("You are a goblin raider. Your tribe spotted a nearby fortress and sent out your group to deal with it."))
	var/client/C = pick_n_take(candidates)
	var/mob/living/carbon/human/species/goblin/leader = new(locate(x+rand(-5,5), y+rand(-5,5), z))
	leader.equipOutfit(/datum/outfit/goblin_leader)
	leader.key = C.key
	spawned_mobs += leader
	to_chat(leader, span_announce("You and yor group were tasked to raid a nearby fortress."))
	return SUCCESSFUL_SPAWN
