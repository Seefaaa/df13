/datum/reagent/spider_venom
	name = "Spider venom"
	description = "Spiders venom"
	color = "#51037a"
	taste_description = "bittery"
	harmful = TRUE
	var/venom_ticks = 0

/datum/reagent/spider_venom/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	venom_ticks++
	if(venom_ticks >= 3)
		if(M.has_status_effect(/datum/status_effect/incapacitating/paralyzed))
		M.apply_status_effect(/datum/status_effect/incapacitating/paralyzed, 10 SECONDS)

/datum/reagent/spider_venom/on_mob_end_metabolize(mob/living/living_anthill)
	venom_ticks = 0
	return ..()
