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
	var/turf/spawn_turf

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
		if(0 to 2)
			leader_outfit = /datum/outfit/goblin_raid_leader
			warrior_outfit = /datum/outfit/goblin_raid_warrior
		if(2 to 4)
			leader_outfit = /datum/outfit/goblin_raid_leader/middle
			warrior_outfit = /datum/outfit/goblin_raid_warrior/middle
		if(4 to INFINITY)
			leader_outfit = /datum/outfit/goblin_raid_leader/hard
			warrior_outfit = /datum/outfit/goblin_raid_warrior/hard

	var/obj/landmark = pick(GLOB.start_landmarks_map_edge)
	spawn_turf = get_turf(landmark)

/datum/round_event/ghost_role/goblin_raid/proc/select_spawn(x, y)
	var/turf/T = locate(spawn_turf.x +x, spawn_turf.y+y, spawn_turf.z)
	return T

/datum/round_event/ghost_role/goblin_raid/spawn_role()
	var/list/candidates = get_candidates("Goblin", null, FALSE)
	var/list/goblins = list()
	while(spawns > 1)
		var/client/C = pick_n_take(candidates)
		var/mob/living/carbon/human/species/goblin/warrior = new(select_spawn(rand(-5,5), rand(-5,5)))
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
	var/mob/living/carbon/human/species/goblin/leader = new(select_spawn(rand(-5,5), rand(-5,5)))
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
