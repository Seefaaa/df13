SUBSYSTEM_DEF(materials)
	name = "Materials"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MATERIALS

	var/list/palettes = list()
	var/list/materials = list()
	var/list/alloy_recipes = list()

/datum/controller/subsystem/materials/Initialize(start_timeofday)
	var/icon/P = icon('dwarfs/icons/palettes.dmi')
	var/list/states = P.IconStates()
	for(var/state in states)
		palettes[state] = icon('dwarfs/icons/palettes.dmi', state)

	for(var/material_type in subtypesof(/datum/material))
		var/datum/material/M = new material_type
		materials[material_type] = M

	for(var/recipe_type in subtypesof(/datum/alloy_recipe))
		var/datum/alloy_recipe/alloy_recipe = new recipe_type
		alloy_recipes += alloy_recipe

	return ..()

/proc/get_material(type)
	if(islist(type))
		return
	return SSmaterials.materials[type]

/proc/get_material_name(type)
	var/datum/material/M = get_material(type)
	if(!M)
		return "unknown material"
	return M.name
