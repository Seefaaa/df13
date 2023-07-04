/mob/proc/get_skill(skill_type)
	return type_from_list(skill_type, known_skills)

///Return the amount of EXP needed to go to the next level. Returns 0 if max level
/mob/proc/exp_needed_to_level_up(skill)
	var/lvl = update_skill_level(skill)
	var/datum/skill/S = get_skill(skill)
	if (lvl >= length(SKILL_EXP_LIST)) //If we're already past the last exp threshold
		return 0
	return SKILL_EXP_LIST[lvl+1] - S.experience

///Adjust experience of a specific skill
/mob/proc/adjust_experience(skill, amt, silent = FALSE, force_old_level = 0)
	var/datum/skill/S = get_skill(skill)
	if(!S)
		S = new skill(src)
		known_skills.Add(S)
	var/old_level = force_old_level ? force_old_level : S.level //Get current level of the S skill
	experience_multiplier = initial(experience_multiplier)
	for(var/key in experience_multiplier_reasons)
		experience_multiplier += experience_multiplier_reasons[key]
	S.experience = max(0, S.experience + amt*experience_multiplier) //Update exp. Prevent going below 0
	S.level = update_skill_level(skill)//Check what the current skill level is based on that skill's exp
	if(silent)
		return
	if(S.level > old_level)
		for(var/i in 1 to S.level-old_level)
			S.level_gained(src, old_level+i, old_level)
	else if(S.level < old_level)
		S.level_lost(src, S.level, old_level)

///Set experience of a specific skill to a number
/mob/proc/set_experience(skill, amt, silent = FALSE)
	var/datum/skill/S = get_skill(skill)
	if(!S)
		S = new skill(src)
		known_skills.Add(S)
	var/old_level = S.experience
	S.experience = amt
	adjust_experience(skill, 0, silent, old_level) //Make a call to adjust_experience to handle updating level

///Set level of a specific skill
/mob/proc/set_level(skill, newlevel, silent = FALSE)
	var/oldlevel = get_skill_level(skill)
	var/difference = SKILL_EXP_LIST[newlevel] - SKILL_EXP_LIST[oldlevel]
	adjust_experience(skill, difference, silent)

///Check what the current skill level is based on that skill's exp
/mob/proc/update_skill_level(skill)
	var/i = 0
	var/datum/skill/S = get_skill(skill)
	for (var/exp in SKILL_EXP_LIST)
		i ++
		if (S.experience >= SKILL_EXP_LIST[i])
			continue
		return i - 1 //Return level based on the last exp requirement that we were greater than
	return i //If we had greater EXP than even the last exp threshold, we return the last level

///Gets the skill's singleton and returns the result of its get_skill_modifier
/mob/proc/get_skill_modifier(skill, modifier)
	var/datum/skill/S = get_skill(skill)
	if(!S)
		S = new skill(src)
		var/skill_modifier = S.get_skill_modifier(modifier, S.level)
		qdel(S)
		return skill_modifier
	return S.get_skill_modifier(modifier, S.level)

///Gets the player's current level number from the relevant skill
/mob/proc/get_skill_level(skill)
	var/datum/skill/S = get_skill(skill)
	return S?.level ? S.level : 1

///Gets the player's current exp from the relevant skill
/mob/proc/get_skill_exp(skill)
	var/datum/skill/S = get_skill(skill)
	return S?.experience ? S.experience : 0

/mob/proc/get_skill_level_name(skill)
	var/level = get_skill_level(skill)
	return SSskills.level_names[level]

/mob/proc/print_levels(user)
	if(!length(known_skills))
		to_chat(user, span_notice("You don't have any skills."))
		return
	var/msg = span_info("<EM>My skills</EM>")
	for(var/datum/skill/S in known_skills)
		msg += span_notice("\n[S.name] - [get_skill_level_name(S.type)]")
		if(S.level != 11)
			msg += span_blue(": [round(S.experience/SKILL_EXP_LIST[S.level+1], 0.01)*100]% until [SSskills.level_names[S.level+1]]")

	to_chat(user, "<div class='examine_block'>[msg]</div>")
