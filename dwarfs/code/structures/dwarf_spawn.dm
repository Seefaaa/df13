/obj/structure/dwarf_spawner
	name = "odd rock"
	desc = "You feel as if a new dwarf could spring from it any second!"
	icon = 'dwarfs/icons/structures/sarcophagus.dmi'
	icon_state = "sarcophagus"

/obj/structure/dwarf_spawner/attack_ghost(mob/user)
	if(SSticker.current_state >= GAME_STATE_PLAYING)
	if(!isobserver(user))
		return ..()
	var/check = tgui_alert(user, "Do you wish to spawn as dwarf?", "Dwarf spawn", list("Yes","No"))
	var/mob/dead/observer/O = user
	if(check == "Yes")
		var/mob/living/carbon/human/new_dwarf = O.create_character(TRUE)
		new_dwarf.equipOutfit(new_dwarf.client?.prefs?.loadout ? new_dwarf.client.prefs.loadout : /datum/outfit/dwarf/miner)// if for SOME reason the pref is null
		new_dwarf.mind.assigned_role = "Dwarf"
		if(new_dwarf)
			new_dwarf.forceMove(loc)
			qdel(src)
	return ..()

