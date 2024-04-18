/datum/smite/offer_mob
	name = "Offer mob to ghosts"

/datum/smite/offer_mob/effect(client/user, mob/living/target)
	. = ..()
	var/list/mob/ghosts = poll_ghost_candidates("Do you wish to play as [target]?")
	if(ghosts.len)
		var/mob/chosen = pick(ghosts)
		target.ghostize(FALSE)
		target.key = chosen.key
		target.client?.init_verbs()
