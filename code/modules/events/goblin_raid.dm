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

/datum/round_event/ghost_role/goblin_raid/pre_start()
	var/live_dwarves = 0
	for(var/mob/living/carbon/human/H in GLOB.dwarf_list)
		if(!H)
			continue
		if(H.stat == DEAD)
			continue
		live_dwarves++
	spawns = 2 + round(live_dwarves / 8)

/datum/round_event/ghost_role/goblin_raid/spawn_role()
	var/list/candidates = get_candidates("Goblin", null, FALSE)
	var/x
	var/y
	var/z = GLOB.surface_z
	if(prob(50))//spawn on top/bottom
		x = rand(10, world.maxx-10)
		y = pick(10, world.maxy-10)
	else//spawn on left/right side
		y = rand(10, world.maxx-10)
		x = pick(10, world.maxy-10)
	var/list/goblins = list()
	while(spawns > 1)
		var/client/C = pick_n_take(candidates)
		var/mob/living/carbon/human/species/goblin/warrior = new(locate(x+rand(-5,5), y+rand(-5,5), z))
		warrior.equipOutfit(/datum/outfit/goblin)
		warrior.a_intent = INTENT_HARM
		if(C)
			warrior.key = C.key
		else
			warrior.ai_controller = new /datum/ai_controller/goblin(warrior)
		spawned_mobs += warrior
		goblins += warrior
		to_chat(warrior, span_announce("You are a goblin raider. Your tribe spotted a nearby fortress and sent out your group to deal with it."))
		spawns--
	var/client/C = pick_n_take(candidates)
	var/mob/living/carbon/human/species/goblin/leader = new(locate(x+rand(-5,5), y+rand(-5,5), z))
	leader.equipOutfit(/datum/outfit/goblin_leader)
	if(C)
		leader.key = C.key
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
