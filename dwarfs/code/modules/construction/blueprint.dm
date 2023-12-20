/obj/structure/blueprint
	name = "blueprint"
	desc = "Build it."
	max_integrity = 1
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "blueprint"
	///How long are we building
	var/build_time = 10 SECONDS
	///What are we building
	var/atom/target_structure
	///What is shown in yje UI
	var/atom/display_structure
	///What do we need to build it
	var/list/reqs = list()
	///What materials are allowed or what is the user using
	var/list/req_materials = list()
	///The size of our blueprint = list(x,y)
	var/list/dimensions = list(0,0)
	///Blueprint category displayed in the ui
	var/cat = "misc"

/obj/structure/blueprint/Initialize()
	. = ..()
	if(!display_structure)
		display_structure = target_structure

/obj/structure/blueprint/examine(mob/user)
	. = ..()
	. += "<br>Required materials:"
	. += req_examine()

/obj/structure/blueprint/proc/req_examine()
	. = list()
	for(var/req in reqs)
		. += "<br>[get_req_amount(req)-get_amount(req)] [get_req_name(req)]"

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
	if(ispath(display_structure, /turf))
		target = new display_structure(locate(world.maxx, world.maxy, world.maxz))
	else
		target = new display_structure
	var/mutable_appearance/M = mutable_appearance(target.build_material_icon(initial(display_structure.icon), initial(display_structure.icon_state)))
	if(!isturf(target))
		qdel(target)
	M.color = "#5e8bdf"
	M.alpha = 120
	return M

/obj/structure/blueprint/update_overlays()
	. = ..()
	var/mutable_appearance/M = structure_overlay()
	. += M

/obj/structure/blueprint/proc/get_amount(obj/item/O)
	. = 0
	for(var/obj/item/I in contents)
		if(isatom(O))
			if(istype(I, O.type) || (O.part_name != "part" && O.part_name == I.part_name))
				if(isstack(I))
					var/obj/item/stack/S = I
					. += S.amount
				else
					.++
		else if(ispath(O))
			if(istype(I, O))
				if(isstack(I))
					var/obj/item/stack/S = I
					. += S.amount
				else
					.++
		else
			if(islist(O))
				var/list/parts = O
				if((I.part_name in parts) || O == PART_ANY)
					if(isstack(I))
						var/obj/item/stack/S = I
						. += S.amount
					else
						.++
			else
				if(I.part_name == O || O == PART_ANY)
					if(isstack(I))
						var/obj/item/stack/S = I
						. += S.amount
					else
						.++

/obj/structure/blueprint/proc/get_req(obj/O)
	. = (O.type in reqs) ? O.type : null
	if(!. && O.part_name != "part")//check for part names
		for(var/req in reqs)
			if(ispath(req))
				continue
			if(islist(req))
				var/list/combined_req = req
				if(O.part_name in combined_req)
					return combined_req
			if(req == O.part_name || req == PART_ANY)
				return req
	if(!.)
		return null

/obj/structure/blueprint/proc/get_req_amount(obj/item/O)
	var/req = isatom(O) ? get_req(O) : O
	return req ? reqs[req] : -1

/obj/structure/blueprint/proc/get_total_req_amount()
	. = 0
	for(var/req in reqs)
		. += reqs[req]

/obj/structure/blueprint/proc/get_req_name(req)
	if(ispath(req))
		var/atom/A = req
		return initial(A.name)
	if(istext(req))
		return get_part_name(req)
	if(islist(req))
		. = ""
		var/list/lreq = req
		for(var/i in 1 to lreq.len)
			. += get_part_name(lreq[i])
			if(i != lreq.len)
				. += " or "
		return .

/obj/structure/blueprint/proc/add_material(mob/user, obj/item/I)
	if(!can_accept(user, I))
		return
	if(!additional_check(user, I)) //possibly move this to the proc itself for more detailed explanations
		return
	if(isstack(I))
		var/obj/item/stack/S = I
		var/diff = get_req_amount(S) - get_amount(S)
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
	var/req = get_req(I)
	var/diff = get_req_amount(req)-get_amount(req)
	if(diff < 1)
		to_chat(user, span_warning("[src] already has enough of [I]."))
		return FALSE
	if(req in req_materials)
		if(I.materials != req_materials[req])
			to_chat(user, span_warning("[I] has to be made out of [get_material_name(req_materials[req])]"))
			return FALSE
	else //we accept and remember the material
		req_materials[req] = I.materials

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
	for(var/req in reqs)
		var/amt = reqs[req]
		var/obj/O
		var/req_name = get_req_name(req)
		if(islist(req))
			var/list/lreq = req
			var/_type = get_default_part(lreq[1])
			O = new _type
		else if(istext(req))
			var/_type = get_default_part(req)
			O = new _type
		else
			O = new req
		var/icon/I = icon(O.icon, O.icon_state)
		var/datum/material/M
		if(req in req_materials)
			M = get_material(req_materials[req])
		if(O.materials && !M)
			I = O.build_material_icon(O.icon, O.icon_state)
		else if(M)
			req_name = "[M.name] [req_name]"
			O.apply_material(M.type)
			I = O.icon
		var/icon_path = icon2path(I, user)
		var/list/resource = list("name"=req_name,"amount"=amt,"icon"=icon_path)
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
	target_structure = /obj/structure/chair/stone/throne
	reqs = list(/obj/item/ingot=2, /obj/item/stack/sheet/stone=15, /obj/item/stack/sheet/mineral/gem/diamond=3)
	req_materials = list(/obj/item/ingot=/datum/material/gold)
	cat = "decoration"

/obj/structure/blueprint/stone_chair
	name = "stone chair"
	target_structure = /obj/structure/chair/stone
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

/obj/structure/blueprint/wall/get_req_amount(obj/item/O)
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
	display_structure = /obj/structure/mineral_door/placeholder
	target_structure = /obj/structure/mineral_door/material
	reqs = list(list(PART_PLANKS, PART_STONE)=3, PART_INGOT=1)
	cat = "construction"

/obj/structure/blueprint/stairs
	name = "stairs"
	target_structure = /obj/structure/stairs
	reqs = list(/obj/item/stack/sheet/stone=3)
	cat = "construction"

/obj/structure/blueprint/sign
	name = "sign"
	target_structure = /obj/structure/sign
	cat = "decoration"
	reqs = list(PART_ANY=3)

/obj/structure/blueprint/sarcophagus
	name = "sarcophagus"
	target_structure = /obj/structure/closet/crate/sarcophagus
	reqs = list(/obj/item/stack/sheet/stone=5)
	cat = "decoration"

/obj/structure/blueprint/sapling_pot
	name = "pot"
	target_structure = /obj/structure/sapling_pot
	reqs = list(/obj/item/stack/sheet/stone=5)
	cat = "utils"

/obj/structure/blueprint/bed
	name = "bed"
	target_structure = /obj/structure/bed
	reqs = list(/obj/item/stack/sheet/planks=8)
	cat = "decoration"

/obj/structure/blueprint/crate
	name = "wooden crate"
	target_structure = /obj/structure/closet/crate/wooden
	reqs = list(/obj/item/stack/sheet/planks=8, /obj/item/ingot=1)
	cat = "utils"

/obj/structure/blueprint/demijohn
	name = "demijohn"
	target_structure = /obj/structure/demijohn
	reqs = list(/obj/item/stack/glass=6, /obj/item/stack/sheet/planks=2)
	cat = "food processing"
