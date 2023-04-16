
/mob/living/simple_animal/chicken
	name = "chicken"
	desc = "Loved for its industrial-like quality of mass producing eggs."
	icon = 'dwarfs/icons/mob/animals.dmi'
	icon_state = "chicken_brown"
	maxHealth = 50
	health = 50
	childtype = list(/mob/living/simple_animal/chicken/baby)
	animal_species = /mob/living/simple_animal/chicken
	// Used for icon state: see ./Initialize
	gender = NEUTER
	var/color_txt = "brown"
	var/food_level


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

/mob/living/simple_animal/chicken/attack_hand(mob/living/carbon/human/M)
	. = ..()

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



/mob/living/simple_animal/chicken/rooster/Life(delta_time, times_fired)
	..()


/mob/living/simple_animal/chicken/hen/Life(delta_time,times_fired)
	..()
	egg_progress++
	make_babies()
	if(egg_progress > 99)
		lay_egg()

/mob/living/simple_animal/chicken/hen/proc/lay_egg()
	egg_progress = 0
	new /obj/item/food/egg(src.loc)

/mob/living/simple_animal/chicken/hen
	name = "hen"
	gender = FEMALE
	childtype = list(/obj/item/food/egg/fertile)
	icon_state = "chicken_white"
	icon_dead = "chicken_white_dead"
	var/egg_progress

/mob/living/simple_animal/chicken/rooster
	name = "rooster"
	gender = MALE
	icon_state = "chicken_brown"
	icon_dead = "chicken_brown_dead"
