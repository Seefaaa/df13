/obj/structure/barrel
	name = "barrel"
	desc = "Do a barrel roll."
	icon = 'dwarfs/icons/structures/workshops.dmi'
	icon_state = "barrel"
	var/open = TRUE
	density = 1
	anchored = TRUE
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)

/obj/structure/barrel/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/barrel/Initialize()
	. = ..()
	create_reagents(300, OPENCONTAINER)
	AddComponent(/datum/component/liftable)

/obj/structure/barrel/update_overlays()
	. = ..()
	if(open && reagents.total_volume)
		var/mutable_appearance/M = mutable_appearance(icon, "barrel_overlay")
		M.color = mix_color_from_reagents(reagents.reagent_list)
		. += M

/obj/structure/barrel/update_icon_state()
	. = ..()
	if(open)
		icon_state = "barrel"
	else
		icon_state = "barrel_closed"

/obj/structure/barrel/AltClick(mob/user)
	if(!CanReach(user))
		return
	open = !open
	reagents.flags = open ? OPENCONTAINER : NONE
	to_chat(user, span_notice("You [open? "open" : "close"] \the [src]."))
	update_appearance()

/obj/structure/barrel/attackby(obj/item/I, mob/user, params)
	if(!open)
		return ..()
	if(user.a_intent != INTENT_HARM && reagents.expose(I))
		return TRUE
	. = ..()
