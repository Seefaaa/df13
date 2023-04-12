/obj/structure/plant/tree
	name = "tree"
	desc = "Big green?"
	icon = 'dwarfs/icons/farming/growing_tree_96x96.dmi'
	density = TRUE
	lifespan = INFINITY
	layer = ABOVE_MOB_LAYER
	base_pixel_x = -32
	spread_x = 4
	spread_y = 3
	var/small_log_type = /obj/item/log
	var/large_log_type = /obj/item/log/large
	var/list/small_log_amount = list(0,1,1,2,0,2,0) //a list of small logs with amount corresponding to the growthstage
	var/list/large_log_amount = list(0,0,0,0,1,1,2) //a list of large logs with amount corresponding to the growthstage
	var/cutting_time = 4 SECONDS //time between each chop
	var/cutting_steps = 4 //how many times you have to chop the tree, 1 less because on the last chop you actuely cut it down
	var/current_step = 0

/obj/structure/plant/tree/proc/try_chop(obj/item/tool, mob/living/user)
	to_chat(user, span_notice("You start chopping down [src]..."))
	var/time_mod = user?.mind.get_skill_modifier(/datum/skill/logging, SKILL_SPEED_MODIFIER)
	time_mod = time_mod ? time_mod : 1
	var/channel = playsound(src.loc, 'dwarfs/sounds/tools/axe/axe_chop_long.ogg', 50, TRUE)
	if(tool.use_tool(src, user, cutting_time*time_mod))
		stop_sound_channel_nearby(src, channel)

		user?.mind.adjust_experience(/datum/skill/logging, 3.6)
		if(current_step >= cutting_steps)
			to_chat(user, span_notice("You chop down [src]."))
			chop_tree(get_turf(src))
			qdel(src)
		else
			to_chat(user, span_notice("You cut a fine notch into [src]."))
			current_step++
	else
		stop_sound_channel_nearby(src, channel)

/obj/structure/plant/tree/proc/chop_tree(turf/my_turf)
	if(small_log_type)
		for(var/i in 1 to small_log_amount[growthstage])
			var/obj/L = new small_log_type(my_turf)
			L.apply_material(materials)
	if(large_log_type)
		for(var/i in 1 to large_log_amount[growthstage])
			var/obj/L = new large_log_type(my_turf)
			L.apply_material(materials)

/obj/structure/plant/tree/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_AXE)
		try_chop(I, user)
	else
		. = ..()

/obj/structure/plant/tree/towercap
	name = "towercap"
	desc = "A mushroom-like subterranean tree. Bears tower cap logs once chopped down."
	species = "towercap"
	produced = list(/obj/item/growable/seeds/tree/towercap=2)
	seed_type = /obj/item/growable/seeds/tree/towercap
	health = 100
	icon_ripe = "towercap-7"
	growthstages = 7
	growthdelta = 80 SECONDS
	produce_delta = 120 SECONDS
	materials = /datum/material/wood/towercap

/obj/structure/plant/tree/apple
	name = "apple tree"
	desc = ""
	species = "apple"
	seed_type = /obj/item/growable/seeds/tree/apple
	produced = list(/obj/item/growable/apple=4)
	growthdelta = 1.5 MINUTES
	produce_delta = 5 MINUTES
	materials = /datum/material/wood/apple

/obj/structure/plant/tree/pine
	name = "pine tree"
	desc = ""
	species = "pine"
	seed_type = /obj/item/growable/seeds/tree/pine
	produced = list()
	growthdelta = 2 MINUTES
	produce_delta = 1 MINUTES
	materials = /datum/material/wood/pine
