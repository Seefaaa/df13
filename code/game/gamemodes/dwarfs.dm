/datum/game_mode/dwarfs
	name = "dwarf fortress"
	config_tag = "dwarf_fortress"
	report_type = "dwarf_fortress"
	false_report_weight = 5
	required_players = 0

	required_jobs = list()

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

/datum/game_mode/dwarfs/post_setup(report)
	. = ..()
	var/list/leader_candidates = list()
	for(var/mob/M in GLOB.dwarf_list)
		if(M.client && (ROLE_EXPEDITION_LEADER in M.client.prefs.be_special) && !is_banned_from(M.ckey, ROLE_EXPEDITION_LEADER))
			leader_candidates += M
	if(leader_candidates.len)
		var/mob/chosen_candidate = pick(leader_candidates)
		chosen_candidate.mind.add_antag_datum(/datum/antagonist/expedition_leader)
	return TRUE

/datum/game_mode/dwarfs/generate_report()
	return "AAA"
