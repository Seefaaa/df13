/obj/structure/debris
	name = "debris"
	desc = "Remains of a destroyed structure."
	anchored = TRUE
	icon = 'dwarfs/icons/structures/debris.dmi'
	icon_state = "empty"
	del_on_zimpact = FALSE
	///How can we clean up the debris? null = hands, otherwise uses TOOL_X
	var/cleaning_tool = null

// since debris is a subtype of structure we need to prevent it from doing what the parent does
/obj/structure/debris/spawn_debris()
	return

/obj/structure/debris/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/debris/proc/spawn_loot(mob/user)
	return

/obj/structure/debris/attack_hand(mob/user)
	if(!cleaning_tool)
		to_chat(user, span_notice("You start cleaning up [src]..."))
		if(!do_after(user, 3 SECONDS, src))
			return
		user.visible_message(span_notice("[user] cleans up \the [src]"), span_notice("You clean up [src]."))
		spawn_loot()
		qdel(src)

/obj/structure/debris/attackby(obj/item/I, mob/user, params)
	if(cleaning_tool == I.tool_behaviour)
		to_chat(user, span_notice("You start cleaning up [src]..."))
		if(!I.use_tool(src, user, 4 SECONDS, volume=50))
			return
		user.visible_message(span_notice("[user] cleans up \the [src]"), span_notice("You clean up [src]."))
		spawn_loot()
		qdel(src)
	else
		. = ..()

/obj/structure/debris/structure/spawn_loot(mob/user)
	var/turf/T = get_turf(src)
	for(var/part in materials)
		var/default_part = get_default_part(part)
		//we don't care what type of structure it originally was, just spawn 1 of each. TODO: make structure debris actually care about the original structure
		var/obj/O = new default_part(T)
		O.apply_material(materials[part])

/obj/structure/debris/dirt
	name = "dirt debris"
	desc = "Pieces of dirt remaining after a collapse. Can be gathered for some soil."
	icon_state = "dirt"

/obj/structure/debris/dirt/spawn_loot(mob/user)
	new/obj/item/stack/dirt(get_turf(src), rand(1, 2))

/obj/structure/debris/rock
	name = "small rock debris"
	desc = "Pieces of rocks remaining after a collapse. Can be gathered for some usable rocks."
	icon_state = "rock_small"
	var/min_spawned = 1
	var/max_spawned = 2

/obj/structure/debris/rock/spawn_loot(mob/user)
	for(var/i in 1 to rand(min_spawned, max_spawned))
		var/rock_type = material2resource(materials, FALSE)
		new rock_type(get_turf(src))

/obj/structure/debris/rock/large
	name = "large rock debris"
	desc = "Piece of rock remaining after a collapse. Can be mined for some usable rocks."
	icon_state = "rock_large"
	cleaning_tool = TOOL_PICKAXE
	min_spawned = 2
	max_spawned = 4
	density = 1

/obj/structure/debris/brick
	name = "small brick debris"
	desc = "Pieces of bricks remaining after a collapse. Can be gathered for some usable bricks."
	icon_state = "bricks_small"
	var/min_spawned = 1
	var/max_spawned = 2

/obj/structure/debris/brick/large
	name = "large brick debris"
	desc = "Piece of brick wall remaining after a collapse. Can be mined for some usable bricks."
	icon_state = "bricks_large"
	cleaning_tool = TOOL_PICKAXE
	min_spawned = 2
	max_spawned = 4
	density = 1

/obj/structure/debris/brick/spawn_loot(mob/user)
	for(var/i in 1 to rand(min_spawned, max_spawned))
		var/brick_type = material2resource(materials, TRUE)
		new brick_type(get_turf(src))

/obj/structure/debris/wood
	name = "small wood debris"
	desc = "Pieces of wooden planks remaining after a collapse. Can be gathered for some usable planks."
	icon_state = "planks_small"
	var/min_spawned = 1
	var/max_spawned = 2

/obj/structure/debris/wood/spawn_loot(mob/user)
	for(var/i in 1 to rand(min_spawned, max_spawned))
		var/wood_type = material2resource(materials, TRUE)
		var/obj/wood = new wood_type(get_turf(src))
		wood.apply_material(materials)

/obj/structure/debris/wood/large
	name = "large wood debris"
	desc = "Piece of wooden wall remaining after a collapse. Can be chopped for some usable planks."
	icon_state = "planks_large"
	min_spawned = 2
	max_spawned = 4
	cleaning_tool = TOOL_AXE
	density = 1
