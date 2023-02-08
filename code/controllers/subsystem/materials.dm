SUBSYSTEM_DEF(materials)
	name = "Materials"
	flags = SS_NO_FIRE

	var/list/palettes = list()
	var/list/materials = list()

/datum/controller/subsystem/materials/Initialize(start_timeofday)
	var/icon/P = icon('dwarfs/icons/palettes.dmi')
	var/list/states = P.IconStates()
	for(var/state in states)
		palettes[state] = icon('dwarfs/icons/palettes.dmi', state)

	for(var/t in subtypesof(/datum/material))
		var/datum/material/M = new t
		materials[t] = M

	return ..()

/proc/get_material(type)
	return SSmaterials.materials[type]
