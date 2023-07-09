GLOBAL_VAR_INIT(king, null)

/obj/item/clothing/head/crown
	name = "crown"
	desc = "To show the royal status."
	worn_icon = 'dwarfs/icons/mob/clothing/head.dmi'
	worn_icon_state = "king_crown"
	icon = 'dwarfs/icons/items/clothing.dmi'
	icon_state = "king_crown"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/king_actions = list()
	var/tracking = FALSE

/obj/item/clothing/head/crown/Initialize()
	. = ..()
	GLOB.crowns+=src

/obj/item/clothing/head/crown/Destroy()
    . = ..()
    GLOB.crowns-=src

/obj/item/clothing/head/crown/apply_grade_extra(grade)
	. = ..()
	for(var/datum/action/a in king_actions)
		qdel(a)
	if(grade >= 2)
		king_actions += new /datum/action/item_action/send_message_action(src)
		king_actions += new /datum/action/item_action/show_location(src)
		return
	if(grade >= 1)
		king_actions += new /datum/action/item_action/send_message_action(src)
		return

/obj/item/clothing/head/crown/ui_action_click(mob/user, actiontype)
	if(user.stat != CONSCIOUS)
		return
	if(GLOB.king != user)
		to_chat(user, span_warning("YOU HAVE NO POWER!"))
		return
	if(istype(actiontype,/datum/action/item_action/send_message_action))
		var/msg = stripped_input(user, "What to say?", "Message:")
		if(!msg)
			return
		user.whisper("[msg]")
		send_message(user, "<b>[user]</b>: [msg]")
		return
	if(istype(actiontype,/datum/action/item_action/show_location))
		show_location(user)

/datum/action/item_action/send_message_action
	name = "Send message to subjects"

/obj/item/clothing/head/crown/proc/send_message(mob/user, msg)
	message_admins("DF: [ADMIN_LOOKUPFLW(user)]: [msg]")
	for(var/mob/M in GLOB.dwarf_list)
		to_chat(M, span_revenbignotice("[msg]"))
		var/sound/siren = sound('sound/effects/siren.ogg', volume = 25)
		SEND_SOUND(M, siren)

/datum/action/item_action/show_location
	name = "Show your location to your subjects"

/obj/item/clothing/head/crown/proc/show_location(mob/user)
	if(!user)
		return
	if(tracking)
		tracking = FALSE
		for(var/mob/M in GLOB.human_list)
			if(isdwarf(M))
				M.clear_alert("kingsense")
	else
		tracking = TRUE
		for(var/mob/M in GLOB.human_list)
			if(isdwarf(M))
				var/atom/movable/screen/alert/kingsense/K = M.throw_alert("kingsense", /atom/movable/screen/alert/kingsense)
				K.king = user

/obj/item/clothing/head/crown/attack_self(mob/user)
	. = ..()
	if(GLOB.king)
		var/mob/living/carbon/human/H = GLOB.king
		if(H.stat != DEAD)
			to_chat(user, span_warning("YOU HAVE NO POWER!"))
			return
	if(user == GLOB.king)
		to_chat(user, span_warning("YOU ALREADY HAVE POWER!"))
		return


	if(is_species(user, /datum/species/dwarf))
		make_king(user)
		return

	return

/obj/item/clothing/head/crown/proc/make_king(mob/user)
	GLOB.king = user
	send_message(user, "<b>[user]</b> has been chosen as our leader!")



/atom/movable/screen/alert/kingsense
	name = "King Sense"
	desc = "Allows you to vind your leader."
	icon = 'dwarfs/icons/ui/alerts.dmi'
	icon_state = "king_sense"
	alerttooltipstyle = "dwarf"
	var/angle = 0
	var/atom/movable/king

/atom/movable/screen/alert/kingsense/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSprocessing, src)

/atom/movable/screen/alert/kingsense/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/atom/movable/screen/alert/kingsense/process()
	if(!owner.mind)
		return
	if(king)
		desc = "Your king needs you!"
	else
		return
	var/turf/P = get_turf(king)
	var/turf/Q = get_turf(owner)
	if(isliving(king))
		var/mob/living/real_target = king
		desc = "You are currently tracking [real_target.real_name] in [get_area_name(king)]."
	else
		desc = "You are currently tracking [king] in [get_area_name(king)]."
	if(!P || !Q || (P.get_virtual_z_level()!= Q.get_virtual_z_level())) //The target is on a different Z level, we cannot sense that far.
		if(Q.get_virtual_z_level() - P.get_virtual_z_level() > 0)
			icon_state = "king_sense_down"
		else
			icon_state = "king_sense_up"
		var/matrix/final = matrix(transform)
		final.TurnTo(angle, 0)
		angle = 0
		animate(src, transform = final, time = 5, loop = 0)
		return
	var/target_angle = get_angle(Q, P)
	var/target_dist = get_dist(P, Q)
	cut_overlays()
	switch(target_dist)
		if(0 to 8)
			icon_state = "arrow8"
		if(9 to 15)
			icon_state = "arrow7"
		if(16 to 22)
			icon_state = "arrow6"
		if(23 to 29)
			icon_state = "arrow5"
		if(30 to 36)
			icon_state = "arrow4"
		if(37 to 43)
			icon_state = "arrow3"
		if(44 to 50)
			icon_state = "arrow2"
		if(51 to 57)
			icon_state = "arrow1"
		if(58 to 64)
			icon_state = "arrow0"
		if(65 to 400)
			icon_state = "arrow"
	var/difference = target_angle - angle
	angle = target_angle
	if(!difference)
		return
	var/matrix/final = matrix(transform)
	final.Turn(difference)
	animate(src, transform = final, time = 5, loop = 0)
