/obj/structure/press
	name = "Fluid press"
	desc = "Used to extract sweet and not so sweet juices"
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "press_open"
	density = 1
	anchored = 1
	layer = ABOVE_MOB_LAYER
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)
	var/max_items = 10 // how much fruits it can hold
	var/max_volume = 500 // sus
	var/time_to_juice = 3 SECONDS
	var/busy_juicing = FALSE

/obj/structure/press/Initialize()
	. = ..()
	create_reagents(max_volume)

/obj/structure/press/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/press/examine(mob/user)
	. = ..()
	if(length(contents))
		.+="<br>It has "
		for(var/obj/O in uniquePathList(contents))
			var/amt = count_by_type(contents, O.type)
			.+="[amt] [O.name][amt > 1 ? "s" : ""]"
		.+=" in it."
	if(reagents.total_volume)
		.+="<br>It has [reagents.get_reagent_names()] in it."
	if(!length(contents) && !reagents.total_volume)
		.+="<br>It's empty."

/obj/structure/press/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/growable))
		var/obj/item/growable/G = I
		if(!SEND_SIGNAL(G, COMSIG_ITEM_CAN_SQUEEZE))
			to_chat(user, span_warning("[G] cannot be juiced."))
			return FALSE
		if(length(contents) >= max_items)
			to_chat(user, span_warning("[G] doesn't fit anymore!"))
			return FALSE
		G.forceMove(src)
		to_chat(user, span_notice("You add [G] to [src]."))
		icon_state = "press_open_item"
		update_appearance()
	else if(I.is_refillable())
		var/transfered = reagents.trans_to(I, 10, transfered_by=user)
		if(!transfered)
			return FALSE
		to_chat(user, span_notice("You take [transfered]u from [src]."))
		if(!reagents.total_volume && !contents.len)
			icon_state = "press_open"
		else if(contents.len)
			icon_state = "press_open_item"
		else if(reagents.total_volume)
			icon_state = "press_finished"
		update_appearance()
	else
		return ..()

/obj/structure/press/attackby_secondary(obj/item/I, mob/user, params)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(I.is_refillable())
		var/obj/item/reagent_containers/C = I
		for(var/datum/reagent/R in I.reagents.reagent_list)
			if(SEND_SIGNAL(R, COMSIG_ITEM_CAN_SQUEEZE, C.amount_per_transfer_from_this))
				reagents.add_reagent(R.type, C.amount_per_transfer_from_this)
				I.reagents.remove_reagent(R.type, C.amount_per_transfer_from_this)
				update_appearance()

/obj/structure/press/proc/squeeze()
	if(contents.len)
		var/list/item_types = list()
		var/types_amount = 0
		for(var/obj/item/I in contents)
			if(!(I.type in item_types))
				item_types.Add(I.type)
				types_amount++
		var/obj/item/growable/G = contents[contents.len]
		if(!SEND_SIGNAL(G, COMSIG_ITEM_CAN_SQUEEZE))
			return
		SEND_SIGNAL(G, COSMIG_ITEM_SQUEEZED, src, types_amount)
	else
		for(var/datum/reagent/R in reagents.reagent_list)
			if(!SEND_SIGNAL(R, COMSIG_ITEM_CAN_SQUEEZE, R.volume))
				return
			SEND_SIGNAL(R, COSMIG_ITEM_SQUEEZED, src, 1)

/obj/structure/press/update_overlays()
	. = ..()
	switch(icon_state)
		if("press_working")
			var/pressable = get_pressable()
			if(!pressable)
				return
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/32x64.dmi', "working_overlay")
			if(isitem(pressable))
				var/obj/item/growable/G = contents[length(contents)]
				var/datum/component/pressable/C = G.GetComponent(/datum/component/pressable)
				var/_color = initial(C.liquid_result.color)
				M.color = _color
			else
				var/datum/reagent/R = pressable
				M.color = R.color
			. += M
		if("press_open_item", "press_open")
			var/pressable = get_pressable()
			if(!pressable)
				return
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/32x64.dmi', "item_overlay")
			if(isitem(pressable))
				var/obj/item/growable/G = contents[length(contents)]
				var/datum/component/pressable/C = G.GetComponent(/datum/component/pressable)
				var/_color = initial(C.liquid_result.color)
				M.color = _color
			else
				var/datum/reagent/R = pressable
				M.color = R.color
			. += M
		if("press_finished")
			var/mutable_appearance/M = mutable_appearance('dwarfs/icons/structures/32x64.dmi', "finished_overlay")
			var/_color = mix_color_from_reagents(reagents.reagent_list)
			M.color = _color
			. += M

/obj/structure/press/proc/get_pressable()
	. = FALSE
	if(contents.len)
		return contents[contents.len]
	if(reagents.total_volume)
		for(var/datum/reagent/R in reagents.reagent_list)
			if(SEND_SIGNAL(R, COMSIG_ITEM_CAN_SQUEEZE, R.volume))
				return R

/obj/structure/press/attack_hand(mob/user)
	var/list/choices = list("Juice"=icon('icons/hud/radial.dmi', "radial_juice"), "Eject"=icon('icons/hud/radial.dmi', "radial_eject"))
	var/answer = show_radial_menu(user, src, choices)
	if(answer == "Eject")
		if(!length(contents))
			to_chat(user, span_warning("[src] is empty!"))
			return
		for(var/obj/item/I in contents)
			I.forceMove(get_turf(user))
		if(reagents.maximum_volume)
			icon_state = "press_finished"
		else
			icon_state = "press_open"
		update_appearance()
		to_chat(user, span_notice("You remove everything from [src]."))
	else if(answer == "Juice")
		if(!get_pressable())
			to_chat(user, span_warning("There is nothing to juice!"))
			return
		if(busy_juicing)
			to_chat(user, span_warning("[src] is already being used!"))
			return
		icon_state = "press_working"
		update_appearance()
		to_chat(user, span_notice("You start juicing [src]'s contents..."))
		while(get_pressable())
			if(!do_after(user, time_to_juice, src))
				break
			squeeze()
		to_chat(user, span_notice("You finish working at [src]..."))
		if(!length(contents))
			icon_state = "press_finished"
			update_appearance()
		else
			icon_state = "press_open_item"
			update_appearance()
