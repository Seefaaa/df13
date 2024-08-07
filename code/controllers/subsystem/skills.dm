/*!
This subsystem mostly exists to populate and manage the skill singletons.
*/

SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SKILLS
	///List of level names with index corresponding to skill level
	//List of skill level names. Note that indexes can be accessed like so: level_names[SKILL_LEVEL_NOVICE]
	var/list/level_names = list("Unskilled - Lv0", "Novice - Lv1", "Adequate - Lv2", "Competent - Lv3", "Proficient - Lv4", "Adept - Lv5", "Expert - Lv6", "Accomplished - Lv7", "Master - Lv8", "Grand Master - Lv9", "Legendary - Lv10")
	var/list/level_colors = list("white", "green", "aqua", "teal", "blue", "navy", "magenta", "purple", "red", "yellow", "#FFC300")

/datum/controller/subsystem/skills/Initialize(timeofday)
	InitializeSkills()
	return ..()

/datum/controller/subsystem/skills/proc/InitializeSkills(timeofday)
	return
