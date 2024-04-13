/obj/item/builder_hammer
	name = "builder's hammer"
	desc = "A building engineers main tool - the hammer."
	icon = 'dwarfs/icons/items/tools.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	icon_state = "builder_hammer"
	usesound = 'dwarfs/sounds/tools/hammer/hammer_hit.ogg'
	tool_behaviour = TOOL_BUILDER_HAMMER
	atck_type = BLUNT
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)
	//What do we want to build -> selected in gui
	var/obj/structure/blueprint/selected_blueprint

/obj/item/builder_hammer/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/builder_hammer/proc/generate_blueprints(user)
	var/list/buildable = subtypesof(/obj/structure/blueprint) - /obj/structure/blueprint/large - /obj/structure/blueprint/floor
	var/list/blueprints = list()
	var/list/cats = list()
	//init categories
	for(var/s in buildable)
		var/obj/structure/blueprint/S = s
		var/category = initial(S.cat)
		if(!cats[category])
			cats[category] = list()
	//build recipes data for categories
	for(var/s in buildable)
		var/obj/structure/blueprint/S = new s
		var/atom/original
		if(ispath(S.display_structure, /turf))
			original = new S.display_structure(locate(world.maxx, world.maxy, world.maxz))
		else
			original = new S.display_structure
		var/category = S.cat
		var/list/blueprint = list()
		var/list/resources = S.build_ui_resources(user)
		blueprint["name"] = initial(original.name)
		blueprint["desc"] = initial(original.desc)
		blueprint["icon"] = icon2path(original.get_material_icon(initial(original.icon), initial(original.icon_state)), user)
		blueprint["path"] = S.type
		blueprint["reqs"] = resources
		cats[category]+=list(blueprint)
		qdel(S)
		if(!isturf(original))
			qdel(original)
		//add all categories to blueprints
	for(var/cat in cats)
		blueprints += list(list("name"=cat, "blueprints"=cats[cat]))
	return blueprints

/obj/item/builder_hammer/ui_interact(mob/user, datum/tgui/ui)
  ui = SStgui.try_update_ui(user, src, ui)
  if(!ui)
    ui = new(user, src, "BuilderHammer")
    ui.open()

/obj/item/builder_hammer/ui_static_data(mob/user)
	var/list/data = list()
	var/list/blueprints = generate_blueprints(user)
	data["blueprints"] = blueprints
	return data

/obj/item/builder_hammer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/path = text2path(params["path"])
	var/obj/structure/blueprint/B = path
	to_chat(usr, span_notice("Selected [initial(B.name)] for building."))
	selected_blueprint = B
	ui.close()

/obj/item/builder_hammer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(isopenturf(target) && proximity_flag)
		var/turf/O = target
		if(isopenspace(O) && !(locate(/obj/structure/lattice) in O))
			return
		if(!selected_blueprint)
			to_chat(user, span_warning("[src] doesn't have a blueprint selected!"))
			return
		var/obj/structure/blueprint/B = new selected_blueprint
		var/target_structure = B.target_structure
		var/list/dimensions = B.dimensions
		qdel(B)
		if(!ispath(target_structure, /turf/open))
			var/list/turfs = RECT_TURFS(dimensions[1], dimensions[2], O)
			for(var/turf/T in turfs)
				if(T.is_blocked_turf())
					to_chat(user, span_warning("You have to free the space required to place the blueprint first!"))
					return
		var/obj/structure/blueprint/new_blueprint = new selected_blueprint(O)
		new_blueprint.dir = user.dir
		new_blueprint.update_appearance()
