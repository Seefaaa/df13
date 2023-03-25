
/mob/living/simple_animal/chicken
	name = "chicken"
	desc = "Loved for its industrial-like quality of mass producing eggs."
	icon = 'dwarfs/icons/mob/animals.dmi'
	icon_state = "goat_brown_m"
	maxHealth = 50
	health = 50
	childtype = list(/mob/living/simple_animal/chicken/baby)
	animal_species = /mob/living/simple_animal/chicken
	// Used for icon state: see ./Initialize
	var/color_txt = "brown"
	var/food_level


/mob/living/simple_animal/chicken/Initialize(mapload, _gender=null, _color=null)
	. = ..()
	gender = _gender ? _gender : pick(MALE, FEMALE)
	color_txt = _color ? _color : pick("brown", "grey")
	icon_dead = "goat_[color_txt]_[gender == MALE ? "m" : "f"]_dead"
	icon_state = "goat_[color_txt]_[gender == MALE ? "m" : "f"]"

/mob/living/simple_animal/chicken/attack_hand(mob/living/carbon/human/M)
	. = ..()

/mob/living/simple_animal/chicken/baby
	name = "baby chicken"
	icon_state = "goat_brown_baby"

/mob/living/simple_animal/chicken/baby/Initialize(mapload)
	. = ..()
	icon_state = "goat_[color_txt]_baby"
	icon_dead = "goat_[color_txt]_baby_dead"
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
	var/egg_progress

/mob/living/simple_animal/chicken/rooster
	name = "rooster"
	gender = MALE

// TODO: add milking
