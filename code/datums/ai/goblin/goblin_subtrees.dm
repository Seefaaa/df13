/datum/ai_planning_subtree/goblin_tree/SelectBehaviors(datum/ai_controller/monkey/controller, delta_time)
	var/mob/living/living_pawn = controller.pawn

	if(SHOULD_RESIST(living_pawn))
		controller.queue_behavior(/datum/ai_behavior/resist) //BRO IM ON FUCKING FIRE BRO
		return SUBTREE_RETURN_FINISH_PLANNING //IM NOT DOING ANYTHING ELSE BUT EXTUINGISH MYSELF, GOOD GOD HAVE MERCY.

	if(HAS_TRAIT(controller.pawn, TRAIT_PACIFISM)) //Not a pacifist? lets try some combat behavior.
		return

	var/list/enemies = controller.blackboard[BB_GOBLIN_ENEMIES]
	var/mob/living/selected_enemy
	var/list/valids = list()
	for(var/mob/living/possible_enemy in view(15, living_pawn))
		if(possible_enemy == living_pawn || (!enemies[possible_enemy] && ("goblin" in possible_enemy.faction))) //Are they an enemy? (And do we even care?)
			continue
		// Weighted list, so the closer they are the more likely they are to be chosen as the enemy
		valids[possible_enemy] = CEILING(100 / (get_dist(living_pawn, possible_enemy) || 1), 1)
		if(!ishuman(possible_enemy))
			valids[possible_enemy] = CEILING(valids[possible_enemy] - 15, 1) // target dwarves with higher chance

	selected_enemy = pickweight(valids)

	if(selected_enemy)
		if(!selected_enemy.stat)

			controller.blackboard[BB_GOBLIN_ATTACK_TARGET] = selected_enemy
			controller.current_movement_target = selected_enemy
			if(prob(50))
				controller.queue_behavior(/datum/ai_behavior/battle_screech/goblin)
			controller.queue_behavior(/datum/ai_behavior/goblin_attack_mob)
			return SUBTREE_RETURN_FINISH_PLANNING

	if(!controller.blackboard[BB_GOBLIN_DESTINATION_REACHED])
		controller.queue_behavior(/datum/ai_behavior/move_to_fortress)
		return SUBTREE_RETURN_FINISH_PLANNING

	//wander around randomly to stumble on some targets
	controller.queue_behavior(/datum/ai_behavior/goblin_wander)
	return SUBTREE_RETURN_FINISH_PLANNING

