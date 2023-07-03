/obj/structure/blueprint
	name = "blueprint"
	desc = "Build it."
	max_integrity = 1
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "blueprint"
	//How long are we building
	var/build_time = 10 SECONDS
	//What are we building
	var/atom/target_structure
	//What do we need to build it
	var/list/reqs = list()
	//What materials are allowed or what is the user using
	var/list/req_materials = list()
	//The size of our blueprint = list(x,y)
	var/list/dimensions = list(0,0)
	var/cat = "misc"

/obj/structure/blueprint/examine(mob/user)
	. = ..()
	. += "<br>Required materials:"
	. += req_examine()

/obj/structure/blueprint/proc/req_examine()
	. = list()
	for(var/i in reqs)
		var/obj/O = i
		. += "<br>[get_req_amount(i)-get_amount(i)] [initial(O.name)]"

/obj/structure/blueprint/Destroy()
	for(var/obj/item/I in contents)
		I.forceMove(get_turf(src))
	. = ..()

/obj/structure/blueprint/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(I.tool_behaviour == TOOL_BUILDER_HAMMER)
		if(!can_build(user))
			return
		var/speed_mod = user.get_skill_modifier(/datum/skill/construction, SKILL_SPEED_MODIFIER)
		if(I.use_tool(src, user, build_time * speed_mod, volume=50))
			to_chat(user, span_notice("You build [initial(target_structure.name)]."))
			user.adjust_experience(/datum/skill/construction, rand(10, 50))
			var/turf/spawn_turf = get_turf(src)
			target_structure = get_target_structure()
			var/list/_materials = list()
			for(var/obj/O in contents)
				_materials[O.part_name] = O.materials
			if(ispath(target_structure, /turf/))
				var/turf/T = spawn_turf.PlaceOnTop(target_structure)
				T.apply_material(_materials)
				QUEUE_SMOOTH_BORDERS(T)
				QUEUE_SMOOTH_BORDERS_NEIGHBORS(T)
			else
				var/atom/A = new target_structure(spawn_turf)
				A.dir = dir
				A.apply_material(_materials)
			contents.Cut()
			qdel(src)
	else
		add_material(user, I)

/obj/structure/blueprint/proc/structure_overlay()
	var/atom/target
	if(ispath(target_structure, /turf))
		target = new target_structure(locate(world.maxx, world.maxy, world.maxz))
	else
		target = new target_structure
	var/mutable_appearance/M = mutable_appearance(target.build_material_icon(initial(target_structure.icon), initial(target_structure.icon_state)), layer=ABOVE_MOB_LAYER)
	if(!isturf(target))
		qdel(target)
	M.color = "#5e8bdf"
	M.alpha = 120
	return M

/obj/structure/blueprint/update_overlays()
	. = ..()
	var/mutable_appearance/M = structure_overlay()
	. += M

/obj/structure/blueprint/proc/get_amount(type)
	. = 0
	for(var/obj/item/I in contents)
		if(istype(I, type))
			if(isstack(I))
				var/obj/item/stack/S = I
				. += S.amount
			else
				.++

/obj/structure/blueprint/proc/get_req_amount(type)
	. = reqs[type]
	if(!.)
		return -1

/obj/structure/blueprint/proc/add_material(mob/user, obj/item/I)
	if(!can_accept(user, I))
		return
	if(!additional_check(user, I)) //possibly move this to the proc itself for more detailed explanations
		return
	if(isstack(I))
		var/obj/item/stack/S = I
		var/diff = get_req_amount(S.type) - get_amount(S.type)
		var/to_use = diff <= S.amount ? diff : S.amount
		S.use(to_use)
		var/added = FALSE
		for(var/obj/item/stack/O in locate(I.type) in contents)
			O.amount += to_use
			added = TRUE
			break
		if(!added)
			var/obj/O = new S.type(src, to_use)
			O.materials = S.materials
	else
		I.forceMove(src)
	to_chat(user, span_notice("You add [I] to [src]."))

/obj/structure/blueprint/proc/get_target_structure()
	return target_structure

/// Check whether obj/I can be accepted by the blueprint (primary check)
/obj/structure/blueprint/proc/can_accept(mob/user, obj/I)
	. = TRUE
	var/diff = get_req_amount(I.type)-get_amount(I.type)
	if(diff < 1)
		to_chat(user, span_warning("[src] already has enough of [I]."))
		return FALSE
	if(I.type in req_materials)
		if(I.materials != req_materials[I.type])
			to_chat(user, span_warning("[I] has to be made out of [get_material_name(req_materials[I.type])]"))
			return FALSE
	else
		req_materials[I.type] = I.materials

/// Extra check after we figure obj/material is accepted by can_accept proc
/obj/structure/blueprint/proc/additional_check(mob/user, obj/material)
	return TRUE

/obj/structure/blueprint/proc/can_build(mob/user)
	. = TRUE
	for(var/i in reqs)
		if((get_req_amount(i)-get_amount(i)) > 0)
			to_chat(user, span_warning("[src] is is missing materials to be built!"))
			return FALSE

/obj/structure/blueprint/proc/build_ui_resources(mob/user)
	. = list() // list of lists where each list is a resource data
	for(var/i in reqs)
		var/amt = reqs[i]
		var/obj/O = new i
		var/icon/I = icon(O.icon, O.icon_state)
		var/datum/material/M
		if(i in req_materials)
			M = req_materials[i]
		if(O.materials && !M)
			I = O.build_material_icon(O.icon, O.icon_state)
		else
			O.apply_material(M)
			I = O.icon
		var/icon_path = icon2path(I, user)
		var/list/resource = list("name"=O.name,"amount"=amt,"icon"=icon_path)
		qdel(O)
		. += list(resource)

/obj/structure/blueprint/large //2x1 size
	name = "large blueprint"
	desc = "That's some real construction going on in here."
	icon = 'dwarfs/icons/structures/64x32.dmi'
	icon_state = "blueprint"
	dimensions = list(1,0)

/obj/structure/blueprint/large/brewery
	name = "brewery blueprint"
	target_structure = /obj/structure/brewery/spawner
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/stack/sheet/stone=4 ,/obj/item/ingot=4)
	cat = "food processing"

/obj/structure/blueprint/large/workbench
	name = "workbench blueprint"
	target_structure = /obj/structure/workbench
	reqs = list(/obj/item/stack/sheet/planks=10, /obj/item/ingot=2)
	cat = "craftsmanship"

/obj/structure/blueprint/stove
	name = "stove blueprint"
	target_structure = /obj/structure/stove
	reqs = list(/obj/item/stack/sheet/stone=10, /obj/item/ingot=1)
	cat = "food processing"

/obj/structure/blueprint/oven
	name = "oven blueprint"
	target_structure = /obj/structure/oven
	reqs = list(/obj/item/stack/sheet/stone=15)
	cat = "food processing"

/obj/structure/blueprint/smelter
	name = "smelter blueprint"
	target_structure = /obj/structure/smelter
	reqs = list(/obj/item/stack/sheet/stone=15)
	cat = "craftsmanship"

/obj/structure/blueprint/forge
	name = "forge blueprint"
	target_structure = /obj/structure/forge
	reqs = list(/obj/item/stack/sheet/stone=20)
	cat = "craftsmanship"

/obj/structure/blueprint/quern
	name = "quern blueprint"
	target_structure = /obj/structure/quern
	reqs = list(/obj/item/stack/sheet/stone=8, /obj/item/stack/sheet/planks=2)
	cat = "food processing"

/obj/structure/blueprint/well
	name = "well blueprint"
	target_structure = /obj/structure/well
	reqs = list(/obj/item/stack/sheet/stone=15, /obj/item/stack/sheet/planks=4, /obj/item/ingot=1, /obj/item/stack/sheet/string=5)
	cat = "utils"

/obj/structure/blueprint/anvil
	name = "anvil blueprint"
	target_structure = /obj/structure/anvil
	reqs = list(/obj/item/ingot=5)
	cat = "craftsmanship"

/obj/structure/blueprint/barrel
	name = "barrel blueprint"
	target_structure = /obj/structure/barrel
	reqs = list(/obj/item/ingot=1, /obj/item/stack/sheet/planks=6)
	cat = "utils"

/obj/structure/blueprint/gemcutter
	name = "gemstone grinder blueprint"
	target_structure = /obj/structure/gemcutter
	reqs = list(/obj/item/ingot=1, /obj/item/stack/sheet/planks=6, /obj/item/stack/glass=1)
	cat = "craftsmanship"

/obj/structure/blueprint/altar
	name = "altar blueprint"
	target_structure = /obj/structure/dwarf_altar
	reqs = list(/obj/item/stack/sheet/stone=25, /obj/item/flashlight/fueled/candle=6)
	cat = "decoration"

/obj/structure/blueprint/loom
	name = "loom blueprint"
	target_structure = /obj/structure/loom
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/ingot=1)
	cat = "craftsmanship"

/obj/structure/blueprint/press
	name = "press"
	target_structure = /obj/structure/press
	reqs = list(/obj/item/stack/sheet/planks=10, /obj/item/ingot=1)
	cat = "food processing"

/obj/structure/blueprint/dryer
	name = "tanning rack"
	target_structure = /obj/structure/tanning_rack
	reqs = list(/obj/item/stack/sheet/planks=7)
	cat = "craftsmanship"

/obj/structure/blueprint/throne
	name = "stone throne"
	target_structure = /obj/structure/chair/comfy/stone/throne
	reqs = list(/obj/item/ingot=2, /obj/item/stack/sheet/stone=15, /obj/item/stack/sheet/mineral/gem/diamond=3)
	req_materials = list(/obj/item/ingot=/datum/material/gold)
	cat = "decoration"

/obj/structure/blueprint/stone_chair
	name = "stone chair"
	target_structure = /obj/structure/chair/comfy/stone
	reqs = list(/obj/item/stack/sheet/stone=5)
	cat = "decoration"

/obj/structure/blueprint/wood_chair
	name = "wooden chair"
	target_structure = /obj/structure/chair/wood
	reqs = list(/obj/item/stack/sheet/planks=5)
	cat = "decoration"

/obj/structure/blueprint/wood_table
	name = "wooden table"
	target_structure = /obj/structure/table/wood
	reqs = list(/obj/item/stack/sheet/planks=6)
	cat = "decoration"

/obj/structure/blueprint/stone_table
	name = "stone table"
	target_structure = /obj/structure/table/stone
	reqs = list(/obj/item/stack/sheet/stone=6)
	cat = "decoration"

/obj/structure/blueprint/floor
	name = "floor"
	cat = "construction"
	var/material_required = 1
	var/material_type

/obj/structure/blueprint/floor/tiles
	name = "tile floor"
	target_structure = /turf/open/floor/tiles

/obj/structure/blueprint/floor/tiles/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(M.mat != MATERIAL_STONE)
		return FALSE

/obj/structure/blueprint/floor/bigtiles
	name = "large tile floor"
	target_structure = /turf/open/floor/bigtiles

/obj/structure/blueprint/floor/bigtiles/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(M.mat != MATERIAL_STONE)
		return FALSE

/obj/structure/blueprint/floor/wooden
	name = "wooden floor"
	target_structure = /turf/open/floor/wooden

/obj/structure/blueprint/floor/wooden/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(M.mat != MATERIAL_WOOD)
		return FALSE

/obj/structure/blueprint/floor/wooden/build_ui_resources(mob/user)
	var/obj/O = /obj/item/stack/sheet/planks
	var/icon/I = apply_palettes(icon(initial(O.icon), initial(O.icon_state)), initial(O.materials))
	var/icon_path = icon2path(I, user)
	return list(list("name"="Any Wood Material","amount"=material_required,"icon"=icon_path))

/obj/structure/blueprint/floor/wooden/req_examine()
	. = list()
	. += "<br>[material_required-get_amount(contents.len ? contents[1].type : 0)] any wood material"

/obj/structure/blueprint/floor/can_build(mob/user)
	. = TRUE
	if(get_amount(contents.len ? contents[1].type : 0) != material_required)
		to_chat(user, span_warning("[src] is is missing materials to be built!"))
		return FALSE

/obj/structure/blueprint/floor/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	if(!I.materials)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(!M)
		return FALSE

/obj/structure/blueprint/floor/additional_check(mob/user, obj/material)
	. = TRUE
	if(!material_type)
		material_type = material.materials
	if(material.materials != material_type)
		return FALSE

/obj/structure/blueprint/floor/get_req_amount(type)
	return material_required

/obj/structure/blueprint/floor/build_ui_resources(mob/user)
	var/obj/O = /obj/item/stack/sheet/stone
	var/icon_path = icon2path(initial(O.icon), user, initial(O.icon_state))
	return list(list("name"="Any Stony Material","amount"=material_required,"icon"=icon_path))

/obj/structure/blueprint/floor/req_examine()
	. = ..()
	. += "<br>[material_required-get_amount(contents.len ? contents[1].type : 0)] any stony material"

/obj/structure/blueprint/wall
	name = "wall"
	target_structure = /turf/closed/wall/placeholder
	cat = "construction"
	var/material_required = 4
	var/material_type

/obj/structure/blueprint/wall/req_examine()
	. = ..()
	. += "<br>[material_required-get_amount(contents.len ? contents[1].type : 0)] any valid material"

/obj/structure/blueprint/wall/can_build(mob/user)
	. = TRUE
	if(get_amount(contents.len ? contents[1].type : 0) != material_required)
		to_chat(user, span_warning("[src] is is missing materials to be built!"))
		return FALSE

/obj/structure/blueprint/wall/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	if(!I.materials)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(!M)
		return FALSE
	if(!M.wall_type)
		return FALSE

/obj/structure/blueprint/wall/additional_check(mob/user, obj/material)
	. = TRUE
	if(!material_type)
		material_type = material.materials
	if(material.materials != material_type)
		return FALSE

/obj/structure/blueprint/wall/get_req_amount(type)
	return material_required

/obj/structure/blueprint/wall/build_ui_resources(mob/user)
	var/obj/O = /obj/item/stack/sheet/stone
	var/icon_path = icon2path(initial(O.icon), user, initial(O.icon_state))
	return list(list("name"="Any Valid Material","amount"=material_required,"icon"=icon_path))

/obj/structure/blueprint/wall/get_target_structure()
	var/datum/material/M = get_material(material_type)
	return M.wall_type

/obj/structure/blueprint/door
	name = "door"
	target_structure = /obj/structure/mineral_door/placeholder
	cat = "construction"
	var/material_required = 3
	var/material_type

/obj/structure/blueprint/door/req_examine()
	. = ..()
	. += "<br>[material_required-get_amount(contents.len ? contents[1].type : 0)] any valid material"

/obj/structure/blueprint/door/can_build(mob/user)
	. = TRUE
	if(get_amount(contents.len ? contents[1].type : 0) != material_required)
		to_chat(user, span_warning("[src] is is missing materials to be built!"))
		return FALSE

/obj/structure/blueprint/door/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	if(!I.materials)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(!M)
		return FALSE
	if(!M.door_type)
		return FALSE

/obj/structure/blueprint/door/additional_check(mob/user, obj/material)
	. = TRUE
	if(!material_type)
		material_type = material.materials
	if(material.materials != material_type)
		return FALSE

/obj/structure/blueprint/door/get_req_amount(type)
	return material_required

/obj/structure/blueprint/door/build_ui_resources(mob/user)
	var/obj/O = /obj/item/stack/sheet/stone
	var/icon_path = icon2path(initial(O.icon), user, initial(O.icon_state))
	return list(list("name"="Any Valid Material","amount"=material_required,"icon"=icon_path))

/obj/structure/blueprint/door/get_target_structure()
	var/datum/material/M = get_material(material_type)
	return M.door_type

/obj/structure/blueprint/stairs
	name = "stairs"
	target_structure = /obj/structure/stairs
	reqs = list(/obj/item/stack/sheet/stone=3)
	cat = "construction"

/obj/structure/blueprint/sign
	name = "sign"
	target_structure = /obj/structure/sign
	cat = "decoration"
	var/material_required = 3
	var/material_type

/obj/structure/blueprint/sign/req_examine()
	. = ..()
	. += "<br>[material_required-get_amount(contents.len ? contents[1].type : 0)] any valid material"

/obj/structure/blueprint/sign/can_build(mob/user)
	. = TRUE
	if(get_amount(contents.len ? contents[1].type : 0) != material_required)
		to_chat(user, span_warning("[src] is is missing materials to be built!"))
		return FALSE

/obj/structure/blueprint/sign/can_accept(mob/user, obj/I)
	. = ..()
	if(!.)
		return FALSE
	if(!I.materials)
		return FALSE
	var/datum/material/M = get_material(I.materials)
	if(!M)
		return FALSE
	// if(!M.door_type)
	// 	return FALSE

/obj/structure/blueprint/sign/additional_check(mob/user, obj/material)
	. = TRUE
	if(!material_type)
		material_type = material.materials
	if(material.materials != material_type)
		return FALSE

/obj/structure/blueprint/sign/get_req_amount(type)
	return material_required

/obj/structure/blueprint/sign/build_ui_resources(mob/user)
	var/obj/O = /obj/item/stack/sheet/stone
	var/icon_path = icon2path(initial(O.icon), user, initial(O.icon_state))
	return list(list("name"="Any Valid Material","amount"=material_required,"icon"=icon_path))

/obj/structure/blueprint/sarcophagus
	name = "Sarcophagus"
	target_structure = /obj/structure/closet/crate/sarcophagus
	reqs = list(/obj/item/stack/sheet/stone=5)
	cat = "decoration"

/obj/structure/blueprint/sapling_pot
	name = "Pot"
	target_structure = /obj/structure/sapling_pot
	reqs = list(/obj/item/stack/sheet/stone=5)
	cat = "utils"
