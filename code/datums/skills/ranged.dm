/datum/skill/ranged
	name = "Generic Ranged skill"
	title = "Gunner"
	/*****************************************IMPORTANT*************************************************/
	//EVERY SKILL UNDER ranged/... HAS TO HAVE THE SAME MODIFIERS AS PARENT OTHERWISE SHIT WILL FUCK UP//
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(3, 2.5, 2, 1.7, 1.4, 1.2, 1.1, 1, 0.9, 0.7, 0.6),
		SKILL_DAMAGE_MODIFIER = list(-3, -2, -1, 0, 1, 2, 2, 3, 4, 5, 6)
	)
	var/exp_per_shot = 1
	var/exp_per_hit = 16

/datum/skill/ranged/bow
	name = "Bow Combat"
	title = "Archer"
	desc = "The art of shooting a bow"
	exp_per_shot = 2
	exp_per_hit = 22

/datum/skill/ranged/crossbow
	name = "Crossbow Combat"
	title = "Crossbowman"
	desc = "The art of shooting a crossbow"
	exp_per_hit = 19
