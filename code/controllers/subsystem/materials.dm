SUBSYSTEM_DEF(materials)
	name = "Materials"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MATERIALS

	var/list/palettes = list()
	var/list/materials = list()
	var/list/alloy_recipes = list()
	var/list/smithing_recipes = list()
	var/list/smithing_recipes_type = list()
	var/list/material_icons = list()

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

	for(var/recipe_type in subtypesof(/datum/smithing_recipe))
		var/datum/smithing_recipe/recipe = new recipe_type
		if(!(recipe.cat in smithing_recipes))
			smithing_recipes[recipe.cat] = list()
		smithing_recipes[recipe.cat] += recipe
		smithing_recipes_type[recipe.type] = recipe

	return ..()
