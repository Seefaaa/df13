/datum/smite/offer_mob
	name = "Offer mob to ghosts"

/datum/smite/offer_mob/effect(client/user, mob/living/target)
	. = ..()
	var/list/mob/ghosts = poll_ghost_candidates("Do you wish to play as [target]?")
	if(ghosts)
		var/mob/chosen = pick(ghosts)
		chosen?.mind.transfer_to(target)
