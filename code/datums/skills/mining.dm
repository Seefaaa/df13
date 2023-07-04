/datum/skill/mining
	name = "Mining"
	title = "Miner"
	desc = "A dwarf's biggest skill, after drinking."
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(3,2.5,2,1.7,1.4,1.2,1.1,1,0.9,0.7,0.6),
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3)//+This to the base max amount
		)
	var/image/ore_sense
	var/sense_active = FALSE

/datum/skill/mining/New(mob/new_owner)
	. = ..()
	ore_sense = image('dwarfs/icons/ui/alerts.dmi', owner, "ore_sense",)

/datum/skill/mining/Destroy(force, ...)
	. = ..()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(ore_sense)

/datum/skill/mining/level_gained(mob/user, new_level, old_level, silent)
	. = ..()
	if(new_level == 7)
		START_PROCESSING(SSprocessing, src)

/datum/skill/mining/process(delta_time)
	if(level < 7 || QDELETED(owner) || owner.stat == DEAD)
		return PROCESS_KILL
	if(!owner.client) //if player left, just return in case they will return at some point
		return
	for(var/turf/closed/mineral/M in orange(8, owner))
		if(M.mineralType)
			if(!sense_active)
				sense_active = TRUE
				owner.client.images += ore_sense
				to_chat(owner, span_notice("You feel like there is ore nearby."))
			var/angle = get_angle(owner, M)
			var/matrix/new_transform = matrix()
			new_transform.Turn(angle)
			animate(ore_sense, 5, 0, transform=new_transform)
			return
	if(sense_active)
		owner.client.images -= ore_sense
		sense_active = FALSE
