/**********************Mineral deposits**************************/

/turf/closed/mineral //wall piece
	name = "rock"
	icon = 'dwarfs/icons/turf/walls_cavern.dmi'
	icon_state = "rockwall-0"
	smoothing_flags = SMOOTH_BITMASK | SMOOTH_BORDER | SMOOTH_BORDERS
	smoothing_groups = list(SMOOTH_GROUP_CLOSED_TURFS, SMOOTH_GROUP_MINERAL_WALLS)
	canSmoothWith = list(SMOOTH_GROUP_MINERAL_WALLS, SMOOTH_GROUP_CLOSED_TURFS)
	baseturfs = /turf/open/floor/rock
	opacity = TRUE
	density = TRUE
	base_icon_state = "rockwall"
	materials = /datum/material/stone
	debris_type = /obj/structure/debris/rock/large
	var/smooth_icon = 'dwarfs/icons/turf/walls_cavern.dmi'
	var/turf/open/floor/turf_type = /turf/open/floor/rock
	var/obj/item/stack/ore/mineralType = null
	var/mineralAmt = 3
	var/last_act = 0
	var/defer_change = 0

/turf/closed/mineral/Initialize()
	. = ..()
	icon = smooth_icon
	if(z > 0 && z <= SSmapping.map_generators.len)
		var/datum/map_generator/generator = SSmapping.map_generators[z]
		hardness = generator?.hardness_level ? generator?.hardness_level : src::hardness

/turf/closed/mineral/set_smoothed_icon_state(new_junction)
	. = ..()
	update_appearance()

/turf/closed/mineral/update_overlays()
	. = ..()
	if(mineralType && mineralAmt)
		. += draw_ore(smoothing_junction)

/turf/closed/mineral/proc/draw_ore(new_junction)
		var/icon/ore = new(initial(mineralType.ore_icon), "[initial(mineralType.ore_basename)]-[new_junction]")
		. = ore

/turf/closed/mineral/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	if(turf_type)
		underlay_appearance.icon = initial(turf_type.icon)
		underlay_appearance.icon_state = initial(turf_type.icon_state)
		return TRUE
	return ..()

/turf/closed/mineral/attackby(obj/item/I, mob/user, params)
	if (!ISADVANCEDTOOLUSER(user))
		to_chat(usr, span_warning("You don't have the dexterity to do this!"))
		return

	if(I.tool_behaviour == TOOL_PICKAXE)
		var/turf/T = user.loc
		if (!isturf(T))
			return
		var/obj/item/pickaxe/pick = I
		var/hardness_mod = hardness / pick.hardness
		// if(hardness_mod >= 2)
		// 	to_chat(user, span_warning("\The [pick] is too soft to mine [src]."))
		// 	return
		var/time = 3 SECONDS * user.get_skill_modifier(/datum/skill/mining, SKILL_SPEED_MODIFIER) * hardness_mod
		if(last_act + time > world.time)//prevents message spam
			return
		last_act = world.time
		to_chat(user, span_notice("You start picking [src]..."))

		if(I.use_tool(src, user, time, volume=50))
			if(ismineralturf(src))
				to_chat(user, span_notice("You finish cutting into the rock."))
				gets_drilled(user, TRUE)
				SSblackbox.record_feedback("tally", "pick_used_mining", 1, I.type)
	else if(I.tool_behaviour == TOOL_CHISEL)
		var/time = 5 SECONDS * user.get_skill_modifier(/datum/skill/masonry, SKILL_SPEED_MODIFIER)
		to_chat(user, span_notice("You start carving stone wall..."))
		if(I.use_tool(src, user, time, volume=50))
			to_chat(user, span_notice("You finish carving stone wall."))
			user.adjust_experience(/datum/skill/masonry, rand(2,6))
			var/new_materials = materials
			var/turf/wall = ChangeTurf(/turf/closed/wall/stone, baseturfs)
			wall.apply_material(new_materials)
	else
		return attack_hand(user)

/turf/closed/mineral/attackby_secondary(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_PICKAXE)
		var/hardness_mod = hardness / I.hardness
		var/time = 3 SECONDS * user.get_skill_modifier(/datum/skill/mining, SKILL_SPEED_MODIFIER) * hardness_mod
		if(last_act + time > world.time)//prevents message spam
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		last_act = world.time
		to_chat(user, span_notice("You start carving stairs out of [src]..."))
		if(I.use_tool(src, user, time, volume=50))
			if(ismineralturf(src))
				to_chat(user, span_notice("You finish cutting into the rock."))
				var/obj/structure/stairs/S = new(src)
				S.dir = user.dir
				S.apply_material(materials)
				gets_drilled(user, TRUE)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	else
		. = ..()

/turf/closed/mineral/proc/gets_drilled(mob/user, give_exp = FALSE)
	var/to_spawn
	if(user)
		var/min_mod = user.get_skill_modifier(/datum/skill/mining, SKILL_AMOUNT_MIN_MODIFIER)
		var/max_mod = user.get_skill_modifier(/datum/skill/mining, SKILL_AMOUNT_MAX_MODIFIER)
		to_spawn = rand(mineralAmt+min_mod, mineralAmt+max_mod)
		if (mineralType && (mineralAmt > 0) && ispath(mineralType, /obj/item/stack))
			if(to_spawn > 1)
				new mineralType(src, mineralAmt)
				SSblackbox.record_feedback("tally", "ore_mined", mineralAmt, mineralType)
			else
				to_chat(user, span_warning("You failed to collect any ore from [src]!"))
	else// if no human caused this
		if (mineralType && (mineralAmt > 0) && ispath(mineralType, /obj/item/stack))
			new mineralType(src, mineralAmt)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(give_exp)
			if (mineralType && (mineralAmt > 0))
				H.adjust_experience(/datum/skill/mining, initial(mineralType.mine_experience) * to_spawn)
			else
				H.adjust_experience(/datum/skill/mining, 0.8)

	var/flags = NONE
	if(defer_change) // TODO: make the defer change var a var for any changeturf flag
		flags = CHANGETURF_DEFER_CHANGE
	ScrapeAway(null, flags)
	addtimer(CALLBACK(src, PROC_REF(AfterChange)), 1, TIMER_UNIQUE)
	playsound(src, 'sound/effects/break_stone.ogg', 50, TRUE) //beautiful destruction

/turf/closed/mineral/attack_animal(mob/living/simple_animal/user)
	if((user.environment_smash & ENVIRONMENT_SMASH_WALLS) || (user.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		gets_drilled(user)
	..()

/turf/closed/mineral/Bumped(atom/movable/AM)
	..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/obj/item/I = H.is_holding_tool(TOOL_PICKAXE)
		if(I)
			attackby(I, H)
		return
	else
		return

/turf/closed/mineral/acid_melt()
	ScrapeAway()

/turf/closed/mineral/ex_act(severity, target)
	..()
	switch(severity)
		if(3)
			if (prob(75))
				gets_drilled(null, FALSE)
		if(2)
			if (prob(90))
				gets_drilled(null, FALSE)
		if(1)
			gets_drilled(null, FALSE)
	return
