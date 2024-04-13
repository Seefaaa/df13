/mob/living/simple_animal/hostile/retaliate/kobold
	name = "kobold"
	desc = "Small creature that steals your shit."
	icon = 'dwarfs/icons/mob/hostile.dmi'
	icon_state = "kobold"
	health = 30
	maxHealth = 30

/mob/living/simple_animal/hostile/kobold/Initialize()
	. = ..()
	icon_state = pick("kobold", "kobold2")
	icon_dead = icon_state + "_dead"
