
#define CHICK_LIMIT 30
/mob/living/simple_animal/chicken
	name = "chicken"
	desc = "Loved for its industrial-like quality of mass producing eggs."
	icon = 'dwarfs/icons/mob/animals.dmi'
	icon_state = "chicken_brown"
	maxHealth = 25
	health = 25
	butcher_results = list(/obj/item/food/meat/slab/chicken=list(1,4))
	childtype = list(/mob/living/simple_animal/chicken/baby)
	animal_species = /mob/living/simple_animal/chicken
	// Used for icon state: see ./Initialize
	gender = NEUTER
	deathsound = 'dwarfs/sounds/mobs/chicken/death.ogg'
	var/list/idle_sounds = list(
		'dwarfs/sounds/mobs/chicken/idle1.ogg',
		'dwarfs/sounds/mobs/chicken/idle2.ogg',
		'dwarfs/sounds/mobs/chicken/idle3.ogg'
	)
	var/color_txt = "brown"

/mob/living/simple_animal/chicken/Initialize(mapload, _gender=null, _color=null)
	. = ..()
	if(gender != NEUTER)
		return
	gender = _gender ? _gender : pick(MALE, FEMALE)
	if(gender == MALE)
		new /mob/living/simple_animal/chicken/rooster(src.loc)
	else
		new /mob/living/simple_animal/chicken/hen(src.loc)
	qdel(src)

/mob/living/simple_animal/chicken/Life(delta_time, times_fired)
	. = ..()
	if(prob(10))
		playsound(src, pick(idle_sounds), rand(20, 60), TRUE)

/mob/living/simple_animal/chicken/baby
	name = "baby chicken"
	icon_state = "chicken_baby"
	icon_dead = "chicken_baby_dead"

/mob/living/simple_animal/chicken/baby/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, .proc/grow_up), 4 MINUTES)

/mob/living/simple_animal/chicken/baby/proc/grow_up()
	if(!src)
		return
	if(gender == FEMALE)
		new /mob/living/simple_animal/chicken/hen(get_turf(src), gender, color_txt)
	if(gender == MALE)
		new /mob/living/simple_animal/chicken/rooster(get_turf(src), gender, color_txt)
	qdel(src)

/mob/living/simple_animal/chicken/hen
	name = "hen"
	gender = FEMALE
	icon_state = "chicken_white"
	icon_dead = "chicken_white_dead"
	var/egg_progress = 0
	var/fertile = 0

/mob/living/simple_animal/chicken/hen/Life(delta_time,times_fired)
	. = ..()
	egg_progress++
	if(egg_progress > 99)
		lay_egg()

/mob/living/simple_animal/chicken/hen/proc/lay_egg()
	egg_progress = 0
	if(fertile)
		new /obj/item/food/egg/fertile(src.loc)
		fertile = FALSE
	else
		new /obj/item/food/egg(src.loc)

/mob/living/simple_animal/chicken/rooster
	name = "rooster"
	gender = MALE
	icon_state = "chicken_brown"
	icon_dead = "chicken_brown_dead"
	idle_sounds = list(
		'dwarfs/sounds/mobs/chicken/idle1.ogg',
		'dwarfs/sounds/mobs/chicken/idle2.ogg',
		'dwarfs/sounds/mobs/chicken/idle3.ogg',
		'dwarfs/sounds/mobs/chicken/idle_rooster.ogg',
	)

/mob/living/simple_animal/chicken/rooster/Life(delta_time, times_fired)
	. = ..()
	make_babies()

/mob/living/simple_animal/chicken/rooster/make_babies()
	if(stat || next_scan_time > world.time || !childtype || !animal_species || !SSticker.IsRoundInProgress())
		return
	next_scan_time = world.time + 400
	var/chick_count = length(/mob/living/simple_animal/chicken in oview(7,src))
	if(chick_count > CHICK_LIMIT)
		return
	var/alone = TRUE
	var/mob/living/simple_animal/partner
	var/children = 0
	var/friends = 0
	for(var/mob/M in view(7, src))
		if(M.stat != CONSCIOUS) //Check if it's conscious FIRST.
			continue
		var/is_child = is_type_in_list(M, childtype)
		var/is_same_species = istype(M, animal_species)
		if(is_child) //Check for children SECOND.
			children++
		else if(is_same_species)
			friends++
			if(M.ckey)
				continue
			else if(!is_child && M.gender == FEMALE && !(M.flags_1 & HOLOGRAM_1)) //Better safe than sorry ;_;
				partner = M

		else if(isliving(M) && !faction_check_mob(M)) //shyness check. we're not shy in front of things that share a faction with us.
			return //we never mate when not alone, so just abort early
	if(alone && partner && (children < 3) && (friends < 8))
		if(istype(partner,/mob/living/simple_animal/chicken/hen))
			var/mob/living/simple_animal/chicken/hen/H = partner
			if(!H.fertile)
				walk_to(src, H, 0, 6)
				sleep(get_dist(src,H) * speed)
				fertilize(H)
				walk_to(src,0)

/mob/living/simple_animal/chicken/rooster/proc/fertilize(mob/living/simple_animal/chicken/hen/H)
	if(!H.fertile)
		H.fertile = TRUE
