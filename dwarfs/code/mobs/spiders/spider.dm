#define SPIDER_IDLE 0
#define SPINNING_WEB 1
#define LAYING_EGGS 2
#define MOVING_TO_TARGET 3
#define SPINNING_COCOON 4

/mob/living/simple_animal/hostile/giant_spider
	name = "giant spider"
	desc = "Furry and black, it makes you shudder to look at it. This one has sparkling purple eyes."
	icon = 'dwarfs/icons/mob/hostile.dmi'
	icon_state = "spider"
	icon_living = "spider"
	icon_dead = "spider_dead"
	mob_biotypes = list(MOB_ORGANIC, MOB_BUG)
	speak_emote = list("chitters")
	emote_hear = list("chitters")
	speak_chance = 5
	turns_per_move = 1
	butcher_results = list(/obj/item/food/meat/slab/spider = list(1,3))
	maxHealth = 200
	health = 200
	obj_damage = 60
	melee_damage_lower = 5
	melee_damage_upper = 15
	faction = list("spiders", "mining")
	var/busy = SPIDER_IDLE
	pass_flags = PASSTABLE
	move_to_delay = 6
	attack_verb_simple = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	see_in_dark = 4
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	attack_vis_effect = ATTACK_EFFECT_BITE
	stat_attack = UNCONSCIOUS
	robust_searching = TRUE
	var/his_sound = 'dwarfs/sounds/mobs/spider/spiderhiss.ogg'
	var/datum/action/innate/spider/lay_web/lay_web
	var/poison_per_bite = 5
	var/poison_type = /datum/reagent/spider_venom
	var/list/sensed_targets = list()
	var/nested = FALSE
	var/cocooning = FALSE
	COOLDOWN_DECLARE(hiss_cd)

/mob/living/simple_animal/hostile/giant_spider/no_nest
	nested = TRUE

/mob/living/simple_animal/hostile/giant_spider/Initialize(mapload)
	. = ..()
	lay_web = new
	lay_web.Grant(src)

//
/mob/living/simple_animal/hostile/giant_spider/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents)
			L.reagents.add_reagent(poison_type, poison_per_bite)

/mob/living/simple_animal/hostile/giant_spider/MoveToTarget()
	if(..())
		if(get_dist(src,target) <= 5 && COOLDOWN_FINISHED(src, hiss_cd))
			playsound(src.loc,his_sound, 100)
			COOLDOWN_START(src, hiss_cd, 20 SECONDS)


// /mob/living/simple_animal/hostile/giant_spider/handle_automated_action()
// 	if(!..())//AIStatus is off

/mob/living/simple_animal/hostile/giant_spider/handle_automated_movement()
	. = ..()
	if(target)
		return


	for(var/mob/living/carbon/human/M in oview(5, src))
		if(M.stat >= UNCONSCIOUS)
			if(!cocooning)
				cocoon(M)
	var/obj/structure/spider/stickyweb/W = locate() in get_turf(src)
	if(!W)
		lay_web.Activate()

	if(!nested)
		nesting()

/mob/living/simple_animal/hostile/giant_spider/proc/nesting()
	stop_automated_movement = TRUE
	for(var/turf/open/T in view(2,src))
		if(stat == DEAD)
			walk_to(src,0)
			return
		if(target)
			stop_automated_movement = FALSE
			return
		if(isgroundlessturf(T))
			continue
		walk_to(src, T, 0, move_to_delay)
		sleep(get_dist(src,T) * move_to_delay * speed)
		lay_web.Activate()
		sleep(1 SECONDS)
	walk_to(src,0)
	nested = TRUE
	stop_automated_movement = FALSE

/mob/living/simple_animal/hostile/giant_spider/verb/cocoon(mob/living/carbon/H)
	if(!Adjacent(H))
		to_chat(usr, span_warning("You have to be near your target!"))
		return
	if(H.stat >= UNCONSCIOUS)
		stop_automated_movement = TRUE
		cocooning = TRUE
		if(locate(/obj/structure/spider/cocoon) in loc)
			to_chat(usr,span_warning("You cannot make a cocoon on another cocoon!"))
			cocooning = FALSE
			stop_automated_movement = FALSE
			return
		if(do_after(src, 5 SECONDS, H))
			var/obj/structure/spider/cocoon/C = new(src.loc)
			C.encase(H)
		cocooning = FALSE
		stop_automated_movement = FALSE
	else
		to_chat(usr,span_warning("You cannot cocoon them while they are alive!"))


/mob/living/simple_animal/hostile/giant_spider/proc/do_action()
	stop_automated_movement = FALSE

/mob/living/simple_animal/hostile/giant_spider/proc/on_sense(source,atom/movable/target)
	if(!istype(target,/mob/living/carbon))
		return
	if(target in sensed_targets)
		return
	sensed_targets += target

/mob/living/simple_animal/hostile/giant_spider/proc/on_unsense(atom/movable/target)
	sensed_targets -= target


/mob/living/simple_animal/hostile/giant_spider/ListTargets()
	. = ..()
	. += sensed_targets

// /mob/living/simple_animal/hostile/giant_spider/movement_delay()
// 	var/turf/T = get_turf(src)
// 	if(locate(/obj/structure/spider/stickyweb) in T)
// 		speed = 2
// 	else
// 		speed = 7
// 	. = ..()


/datum/action/innate/spider
	icon_icon = 'icons/mob/actions/actions_animal.dmi'
	background_icon_state = "bg_alien"
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/innate/spider/lay_web
	name = "Spin Web"
	desc = "Spin a web to slow down potential prey."
	button_icon_state = "lay_web"

/datum/action/innate/spider/lay_web/Activate()
	if(!istype(owner, /mob/living/simple_animal/hostile/giant_spider))
		return
	var/mob/living/simple_animal/hostile/giant_spider/S = owner

	if(!isturf(S.loc))
		return
	var/turf/T = get_turf(S)

	var/obj/structure/spider/stickyweb/W = locate() in T
	if(W)
		to_chat(S, "<span class='warning'>There's already a web here!</span>")
		return

	if(S.busy != SPINNING_WEB)
		S.busy = SPINNING_WEB
		S.visible_message("<span class='notice'>[S] begins to secrete a sticky substance.</span>","<span class='notice'>You begin to lay a web.</span>")
		S.stop_automated_movement = TRUE
		if(do_after(S, 1, target = T))//40
			if(S.busy == SPINNING_WEB && S.loc == T)
				var/obj/structure/spider/stickyweb/newweb = new /obj/structure/spider/stickyweb(T)
				newweb.register_spider(CALLBACK(owner, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider, on_sense), target),CALLBACK(owner, TYPE_PROC_REF(/mob/living/simple_animal/hostile/giant_spider, on_unsense), target))
		S.busy = SPIDER_IDLE
		S.stop_automated_movement = FALSE
	else
		to_chat(S, "<span class='warning'>You're already spinning a web!</span>")

