/datum/ai_behavior/battle_screech/goblin
	screeches = list("roar", "screech")

/datum/ai_behavior/goblin_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/goblin_attack_mob/perform(delta_time, datum/ai_controller/controller, ...)
	. = ..()

	var/mob/living/target = controller.blackboard[BB_GOBLIN_ATTACK_TARGET]
	var/mob/living/carbon/owner = controller.pawn

	if(IS_DEAD_OR_INCAP(owner))
		finish_action(controller, FALSE)
		return

	if(!target || target.stat >= HARD_CRIT)
		finish_action(controller, TRUE)
		return
	controller.current_movement_target = target
	attack(controller, delta_time, target)

/datum/ai_behavior/goblin_attack_mob/proc/attack(datum/ai_controller/controller, delta_time, mob/living/target)
	var/mob/living/carbon/human/owner = controller.pawn

	if(owner.next_move > world.time)
		return

	var/obj/item/W = owner.get_active_held_item()
	//occasionally re-check cause who knows if we somehow get a weapon
	if((controller.blackboard[BB_HAS_WEAPONS] || prob(20)) && !W)
		var/list/possible_items = list(owner.l_store, owner.r_store, owner.s_store, owner.back) + owner.held_items
		var/best_force = 0

		//use the best item available
		//this doesn't account for wielded items having 5 force when not wielded. TODO: fix that
		for(var/obj/item/I in possible_items)
			if(!I)
				continue
			if(I.force > best_force)
				best_force = I.force
				W = I

		if(W && !owner.is_holding(W))
			if(!LAZYLEN(owner.get_empty_held_indexes()))
				owner.drop_all_held_items()

			W.attack_hand(owner)

			if(HAS_TRAIT(W, TRAIT_CAN_WIELD) && !HAS_TRAIT(W, TRAIT_WIELDED))
				owner.activate_hand(owner.active_hand_index)

		else if(W && owner.is_holding(W))
			if(owner.get_active_held_item() != W)
				owner.swap_hand(owner.get_inactive_hand_index())

			if(HAS_TRAIT(W, TRAIT_CAN_WIELD) && !HAS_TRAIT(W, TRAIT_WIELDED))
				owner.activate_hand(owner.active_hand_index)

		if(!W)
			controller.blackboard[BB_HAS_WEAPONS] = FALSE

	owner.changeNext_move(W ? W.melee_cd : CLICK_CD_MELEE)
	owner.face_atom(target)
	owner.a_intent = INTENT_HARM

	if(owner.CanReach(target, W))
		if(W)
			W.melee_attack_chain(owner, target)
		else
			owner.UnarmedAttack(target, null)

/datum/ai_behavior/move_to_fortress
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/move_to_fortress/perform(delta_time, datum/ai_controller/controller, ...)
	. = ..()

	if(controller.blackboard[BB_GOBLIN_DESTINATION_REACHED])
		finish_action(controller, TRUE)
		return

	if(controller.blackboard[BB_FOLLOW_TARGET])
		finish_action(controller, FALSE)
		return

	var/mob/living/carbon/owner = controller.pawn

	var/turf/fortress_turf = locate(world.maxx/2, world.maxy/2, GLOB.surface_z)
	if(fortress_turf in view(10, owner))
		finish_action(controller, TRUE)
	else
		controller.current_movement_target = fortress_turf

/datum/ai_behavior/move_to_fortress/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	if(succeeded)
		controller.blackboard[BB_GOBLIN_DESTINATION_REACHED] = TRUE

/datum/ai_behavior/goblin_wander
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM

/datum/ai_behavior/goblin_wander/perform(delta_time, datum/ai_controller/controller, ...)
	. = ..()
	if(prob(50))
		return
	var/mob/living/carbon/owner = controller.pawn
	var/dir = pick(GLOB.alldirs)
	owner.Move(get_step(owner, dir), dir)
	finish_action(controller, TRUE)
