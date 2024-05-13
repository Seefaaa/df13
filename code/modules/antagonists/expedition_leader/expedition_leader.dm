/datum/antagonist/expedition_leader
	name = "Expedition Leader"
	roundend_category = "Expedition Leader"
	job_rank = ROLE_EXPEDITION_LEADER
	antagpanel_category = "Expedition Leader"
	antag_memory = "You are the Expedition Leader. Your job is to organize the dwarves and help build the Fortress."
	var/datum/action/message_action

/datum/antagonist/expedition_leader/New()
	. = ..()
	message_action = new /datum/action/send_message_to_dwarves()

/datum/antagonist/expedition_leader/greet()
	to_chat(owner, span_warningplain("You are the Expedition Leader. Your job is to organize the dwarves and help build the Fortress."))

/datum/antagonist/expedition_leader/apply_innate_effects(mob/living/mob_override)
	message_action.Grant(owner.current)

/datum/antagonist/expedition_leader/remove_innate_effects(mob/living/mob_override)
	message_action.Remove(owner.current)

/datum/action/send_message_to_dwarves
	name = "Send message to dwarves"
	button_icon_state = "message"

/datum/action/send_message_to_dwarves/Trigger()
	. = ..()
	if(!.)
		return FALSE
	var/msg = stripped_input(owner, "What to say?", "Message:")
	message_admins("DF: [ADMIN_LOOKUPFLW(owner)]: [msg]")
	for(var/mob/M in GLOB.dwarf_list)
		to_chat(M, span_revenbignotice("<b>\[EL\][owner]</b>: [msg]"))
		var/sound/siren = sound('sound/effects/siren.ogg', volume = 25)
		SEND_SOUND(M, siren)
