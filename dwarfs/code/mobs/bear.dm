/mob/living/simple_animal/hostile/bear
	name = "bear"
	desc = "Perfect for hugging. Don't complain later."
	icon = 'dwarfs/icons/mob/64x64.dmi'
	base_pixel_x = -16
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 2
	speed = 1.5
	maxHealth = 350
	health = 350
	faction = list("surface")
	see_in_dark = 1
	butcher_results = list(/obj/item/food/meat/slab = list(2,4), /obj/item/food/intestines=list(2,4), /obj/item/stack/sheet/tallow=list(4,6))
	hide_type = /obj/item/stack/sheet/animalhide/bear
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_vis_effect = ATTACK_EFFECT_CLAW
	gold_core_spawnable = HOSTILE_SPAWN
	move_force = MOVE_FORCE_VERY_STRONG
	move_resist = MOVE_FORCE_VERY_STRONG
	pull_force = MOVE_FORCE_VERY_STRONG
	a_intent = INTENT_HARM
	stat_attack = HARD_CRIT
	atck_type = SHARP // bear claws are sharp
	robust_searching = 1
	deathsound = 'dwarfs/sounds/mobs/bear/death.ogg'
	var/list/idle_sounds = list('dwarfs/sounds/mobs/bear/idle1.ogg', 'dwarfs/sounds/mobs/bear/idle2.ogg')

/mob/living/simple_animal/hostile/bear/Life(delta_time, times_fired)
	. = ..()
	if(prob(10))
		playsound(src, pick(idle_sounds), rand(20, 60), TRUE)
