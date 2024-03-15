/obj/item/stack/ore/stone
	name = "rock"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "rock"
	singular_name = "Rock piece"
	max_amount = 1
	init_materials = TRUE

/obj/item/stack/ore/stone/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

//double stone. base type is just a rock, no materials
/obj/item/stack/ore/stone/stone
	desc = "A rock. Can be chiseled into a brick or ground into flux."
	materials = /datum/material/stone

/obj/item/stack/ore/stone/stone/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	AddComponent(/datum/component/grindable, item_type=/obj/item/stack/sheet/flux)

/obj/item/stack/ore/stone/sand
	desc = "A rock. Can be chiseled into a brick or ground into sand."
	materials = /datum/material/sandstone

/obj/item/stack/ore/stone/sand/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	AddComponent(/datum/component/grindable, item_type=/obj/item/stack/ore/smeltable/sand)

/obj/item/stack/ore/stone/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_CHISEL)
		var/speed_mod = user.get_skill_modifier(/datum/skill/masonry, SKILL_SPEED_MODIFIER)
		if(I.use_tool(src, user, 1 SECONDS * speed_mod, volume=50))
			if(prob(user.get_skill_modifier(/datum/skill/masonry, SKILL_PROBS_MODIFIER)))
				to_chat(user, span_warning("You process \the [src]."))
				return
			var/obj/O = new /obj/item/stack/sheet/stone(user.loc)
			O.apply_material(materials)
			user.adjust_experience(/datum/skill/masonry, rand(1,4))
			to_chat(user, span_notice("You process \the [src]."))
			use(1)
	else
	 . = ..()

/obj/item/stack/sheet/stone
	name = "stone"
	desc = "Used in building."
	singular_name = "Brick"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "stone_brick"
	inhand_icon_state = "sheet-metal"
	force = 10
	throwforce = 10
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_TINY
	part_name = PART_STONE
	merge_type = /obj/item/stack/sheet/stone
	materials = /datum/material/stone

/obj/item/stack/sheet/stone/build_material_icon(_file, state)
	return apply_palettes(..(), materials)
