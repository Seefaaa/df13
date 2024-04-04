/datum/round_event_control/goblin_raid
	name = "Goblin Raid"
	typepath = /datum/round_event/ghost_role/goblin_raid
	weight = 5
	max_occurrences = INFINITY
	earliest_start = 30 MINUTES
	delay = 20 MINUTES
	min_players = 10

/datum/round_event/ghost_role/goblin_raid
	announceChance = 0
	minimum_required = 1
	role_name = "goblin raider"
	var/spawns = 2
	var/leader_outfit = /datum/outfit/goblin_raid_leader
	var/warrior_outfit = /datum/outfit/goblin_raid_warrior

/datum/round_event/ghost_role/goblin_raid/pre_start()
	var/live_dwarves = 0
	for(var/mob/living/carbon/human/H in GLOB.dwarf_list)
		if(!H)
			continue
		if(H.stat == DEAD)
			continue
		live_dwarves++
	spawns = 2 + round(live_dwarves / 8)
	switch(control.occurrences)
		if(0 to 5)
			leader_outfit = /datum/outfit/goblin_raid_leader
			warrior_outfit = /datum/outfit/goblin_raid_warrior
		if(5 to 10)
			leader_outfit = /datum/outfit/goblin_raid_leader/middle
			warrior_outfit = /datum/outfit/goblin_raid_warrior/middle
		if(10 to INFINITY)
			leader_outfit = /datum/outfit/goblin_raid_leader/hard
			warrior_outfit = /datum/outfit/goblin_raid_warrior/hard

/datum/round_event/ghost_role/goblin_raid/proc/select_spawn(x, y, z)
	var/turf/T = locate(x, y, z)
	while(T.is_blocked_turf() || isclosedturf(T))
		T = get_step(T, pick(GLOB.cardinals))
		if(!T)
			T = locate(x, y, z)
	return T

/datum/round_event/ghost_role/goblin_raid/spawn_role()
	var/list/candidates = get_candidates("Goblin", null, FALSE)
	var/x
	var/y
	var/z = GLOB.surface_z
	for(var/i in 1 to 15)
		if(prob(50))//spawn on top/bottom
			x = rand(10, world.maxx-10)
			y = pick(10, world.maxy-10)
		else//spawn on left/right side
			y = rand(10, world.maxx-10)
			x = pick(10, world.maxy-10)
		var/turf/T = locate(x, y, z)
		if(isclosedturf(T))
			continue
		if((locate(/obj/structure/plant/tree) in range(5, T)))
			continue
		break
	var/list/goblins = list()
	while(spawns > 1)
		var/client/C = pick_n_take(candidates)
		var/mob/living/carbon/human/species/goblin/warrior = new(select_spawn(x+rand(-5,5), y+rand(-5,5), z))
		warrior.equipOutfit(warrior_outfit)
		warrior.a_intent = INTENT_HARM
		if(C)
			warrior.key = C.key
			warrior.throw_alert("goblinsense", /atom/movable/screen/alert/migrant/goblin)
		else
			warrior.ai_controller = new /datum/ai_controller/goblin(warrior)
		// spawned_mobs += warrior // we want to announce goblin leader only
		goblins += warrior
		to_chat(warrior, span_announce("You are a goblin raider. Your tribe spotted a nearby fortress and sent out your group to deal with it."))
		spawns--
	var/client/C = pick_n_take(candidates)
	var/mob/living/carbon/human/species/goblin/leader = new(select_spawn(x+rand(-5,5), y+rand(-5,5), z))
	leader.equipOutfit(leader_outfit)
	if(C)
		leader.key = C.key
		leader.throw_alert("goblinsense", /atom/movable/screen/alert/migrant/goblin)
	else
		leader.ai_controller = new /datum/ai_controller/goblin(leader)
	leader.a_intent = INTENT_HARM
	spawned_mobs += leader
	goblins += leader
	to_chat(leader, span_announce("You and yor group were tasked to raid a nearby fortress."))

	for(var/mob/living/goblin in goblins)
		for(var/mob/living/other_goblin in goblins-goblin)
			var/datum/ai_controller/goblin/goblin_controller = goblin.ai_controller
			if(goblin_controller)
				goblin_controller.add_teammate(other_goblin)
	return SUCCESSFUL_SPAWN
