/datum/reagent/spider_venom
	name = "Spider venom"
	description = "Spiders venom"
	color = "#51037a"
	taste_description = "bittery"
	harmful = TRUE

/datum/reagent/spider_venom/on_mob_life(mob/living/carbon/M, delta_time, times_fired)
	. = ..()
	if(DT_PROB(max(current_cycle * 2 * M.metabolism_efficiency, 0),delta_time))
		if(!M.has_status_effect(/datum/status_effect/incapacitating/paralyzed))
			M.apply_status_effect(/datum/status_effect/incapacitating/paralyzed, 10 SECONDS)



/datum/status_effect/incapacitating/paralyzed/venom
	id = "paralyzedvenom"
	status_type = STATUS_EFFECT_REFRESH
