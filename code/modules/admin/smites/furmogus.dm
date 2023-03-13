/datum/smite/furmogus
	name = "Furmogufy"

/datum/smite/furmogus/effect(client/user, mob/living/target)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/furmogus/sus = new(target)
	target.mind.transfer_to(sus)
	target.gib(TRUE,FALSE,FALSE)
