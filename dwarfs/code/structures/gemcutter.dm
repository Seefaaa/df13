/obj/structure/gemcutter
	name = "gem cutter"
	desc = "Makes items that don't shine to do so."
	icon = 'dwarfs/icons/structures/32x48.dmi'
	icon_state = "gemcutter"
	anchored = TRUE
	density = TRUE
	layer = TABLE_LAYER
	materials = list(PART_PLANKS=/datum/material/wood/pine/treated, PART_INGOT=/datum/material/iron)
	var/busy = FALSE

/obj/structure/gemcutter/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_PLANKS], materials[PART_INGOT]))

/obj/structure/gemcutter/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/ore/gem))
		icon_state = "gemcutter_on"
		if(busy)
			to_chat(user, span_notice("Currently busy."))
			return
		busy = TRUE
		if(!do_after(user, 15 SECONDS, target = src))
			busy = FALSE
			icon_state = "gemcutter"
			return
		busy = FALSE
		var/obj/item/stack/ore/gem/G = I
		new G.cut_type(loc)
		to_chat(user, span_notice("You process [G] on \a [src]"))
		qdel(G)
		icon_state = "gemcutter"
	else
		..()
