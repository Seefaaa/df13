/datum/ai_controller/goblin
	planning_subtrees = list(/datum/ai_planning_subtree/goblin_tree)
	max_target_distance = 150
	ai_movement = /datum/ai_movement/jps
	blackboard = list(
		BB_GOBLIN_ATTACK_TARGET = null,
		BB_GOBLIN_DESTINATION_REACHED = FALSE,
		BB_GOBLIN_ENEMIES = list(),
		BB_FOLLOW_TARGET = null,
		BB_VISION_RANGE = 10,
		BB_HAS_WEAPONS = TRUE,
	)

/datum/ai_controller/goblin/TryPossessPawn(atom/new_pawn)
	if(!isliving(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE

	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_PAW, PROC_REF(on_attack_paw))
	RegisterSignal(new_pawn, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(on_attack_animal))
	RegisterSignal(new_pawn, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignal(new_pawn, COMSIG_ATOM_HITBY, PROC_REF(on_hitby))
	RegisterSignal(new_pawn, COMSIG_LIVING_START_PULL, PROC_REF(on_startpulling))
	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(update_movespeed))

	movement_delay = living_pawn.cached_multiplicative_slowdown
	return ..() //Run parent at end

/datum/ai_controller/goblin/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_LIVING_START_PULL,\
	COMSIG_MOB_MOVESPEED_UPDATED, COMSIG_ATOM_ATTACK_ANIMAL))
	qdel(GetComponent(/datum/component/connect_loc_behalf))

/datum/ai_controller/goblin/proc/retaliate(mob/living/L)
	var/list/enemies = blackboard[BB_GOBLIN_ENEMIES]
	enemies[L] = 100
	blackboard[BB_GOBLIN_ATTACK_TARGET] = L
	queue_behavior(/datum/ai_behavior/goblin_attack_mob)

/datum/ai_controller/goblin/proc/on_attackby(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER
	if(I.force && I.damtype != STAMINA)
		retaliate(user)

/datum/ai_controller/goblin/proc/on_attack_hand(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(prob(GOBLIN_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/goblin/proc/on_attack_paw(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(prob(GOBLIN_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/goblin/proc/on_attack_animal(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(user.melee_damage_upper > 0 && prob(GOBLIN_RETALIATE_PROB))
		retaliate(user)

/datum/ai_controller/goblin/proc/on_bullet_act(datum/source, obj/projectile/Proj)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(istype(Proj, /obj/projectile/bullet))
		if((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE))
			if(!Proj.nodamage && Proj.damage < living_pawn.health && isliving(Proj.firer))
				retaliate(Proj.firer)

/datum/ai_controller/goblin/proc/on_hitby(datum/source, atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(istype(AM, /obj/item))
		var/mob/living/living_pawn = pawn
		var/obj/item/I = AM
		var/mob/thrown_by = I.thrownby?.resolve()
		if(I.throwforce < living_pawn.health && ishuman(thrown_by))
			var/mob/living/carbon/human/H = thrown_by
			retaliate(H)

/datum/ai_controller/goblin/proc/on_startpulling(datum/source, atom/movable/puller, state, force)
	SIGNAL_HANDLER
	var/mob/living/living_pawn = pawn
	if(!IS_DEAD_OR_INCAP(living_pawn) && prob(GOBLIN_RETALIATE_PROB)) // nuh uh you don't pull me!
		retaliate(living_pawn.pulledby)
		return TRUE

/datum/ai_controller/goblin/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown

/datum/ai_controller/goblin/proc/check_verbal_command(mob/speaker, speech_args)
	SIGNAL_HANDLER

	var/mob/living/living_pawn = pawn
	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	if(!("goblin" in speaker.faction))
		return
	if(!can_see(pawn, speaker, length=10))
		return

	var/spoken_text = speech_args[SPEECH_MESSAGE] // probably should check for full words
	if(findtext(spoken_text, "stop") || findtext(spoken_text, "stay"))
		blackboard[BB_FOLLOW_TARGET] = null
	else if((findtext(spoken_text, "follow") || findtext(spoken_text, "come")))
		blackboard[BB_FOLLOW_TARGET] = WEAKREF(speaker)
		queue_behavior(/datum/ai_behavior/follow)

/datum/ai_controller/goblin/proc/add_teammate(mob/teammate)
	RegisterSignal(teammate, COMSIG_MOB_SAY, PROC_REF(check_verbal_command))
