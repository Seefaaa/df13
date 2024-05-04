/datum/skill/climbing
	name = "Climbing"
	title = "Climber"
	desc = "Scale cliffs and mountains with ease."
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(3, 2.5, 2, 1.5, 1.2, 1,1 , 0.9, 0.8, 0.7, 0.6),
		SKILL_AMOUNT_MAX_MODIFIER = list(60, 50, 40, 35, 30, 25, 20, 15, 10, 5, 0),
		SKILL_AMOUNT_MIN_MODIFIER = list(45, 40, 35, 30, 25, 20, 15, 10, 10, 5, 0)
	)
	obtainable_in_prefs = FALSE
