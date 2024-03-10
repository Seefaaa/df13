/proc/get_part_name(part)
	switch(part)
		if(PART_ANY)
			return "anything"
		if(PART_HANDLE)
			return "handle"
		if(PART_HEAD)
			return "tool head"
		if(PART_INGOT)
			return "ingot"
		if(PART_PLANKS)
			return "any planks"
		if(PART_STONE)
			return "any stone"
		else
			return "unidentified part"

/proc/material2resource(material, refined=TRUE)
	if(!ispath(material, /datum/material))
		CRASH("Bad material argument in material2resource.")
	var/datum/material/M = get_material(material)
	return refined ? M.resource_refined : M.resource

/proc/get_default_part(part)
	switch(part)
		if(PART_HANDLE)
			return /obj/item/stick
		if(PART_HEAD)
			return /obj/item/partial/axe
		if(PART_INGOT)
			return /obj/item/ingot
		if(PART_PLANKS)
			return /obj/item/stack/sheet/planks
		if(PART_STONE)
			return /obj/item/stack/sheet/stone
		else
			return /obj/item/stack/sheet/stone

/// Get uniqie material types from material list. Can handle anything from single material objects to multi-part objects.
/proc/materials2mats(list/materials)
	. = list()
	//convert single material objects into list so we don't have to handle them separately
	if(!islist(materials))
		materials = list(materials)
	for(var/possible_material_type in materials)
		// multi-part object
		if(istext(possible_material_type))
			possible_material_type = materials[possible_material_type]
		var/datum/material/material = get_material(possible_material_type)
		//sanity check
		if(!material)
			continue
		if(material.mat)//if material has material type assigned, add it to the list
			.[material.mat] = material.type

/// Convert material types into corresponding debree image.
/proc/mats2debris(list/mats)
	var/image/debris = image('dwarfs/icons/technical.dmi', null, "transparent")
	if(MATERIAL_METAL in mats)
		debris.overlays += apply_palettes(icon('dwarfs/icons/structures/debris.dmi', "metal"), mats[MATERIAL_METAL])
	if(MATERIAL_STONE in mats)
		debris.overlays += apply_palettes(icon('dwarfs/icons/structures/debris.dmi', "stone"), mats[MATERIAL_STONE])
	if(MATERIAL_WOOD in mats)
		debris.overlays += apply_palettes(icon('dwarfs/icons/structures/debris.dmi', "wood"), mats[MATERIAL_WOOD])
	return debris

/proc/get_material(type)
	if(islist(type))
		return
	return SSmaterials.materials[type]

/proc/get_material_name(type)
	var/datum/material/M = get_material(type)
	if(!M)
		return "unknown material"
	return M.name
