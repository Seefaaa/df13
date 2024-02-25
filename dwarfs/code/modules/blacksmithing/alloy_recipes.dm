/// Represents an alloy recipe made in alloy smelter
/datum/alloy_recipe
	/// Result obj path. Usually it's the ingot
	var/result = /obj/item/ingot
	/// Resulting material applied to the result
	var/result_material = /datum/material/iron
	/// How much of the result is spawned
	var/result_amount = 1
	/// Required materials for this recipe
	var/list/reqs
	/// Required materials assigned to each req. Uses indexes cause most alloys will use the same ingredients twice. if there's no material or material preference for the req, use anu text
	var/list/req_materials
	/// How much exp towards the blacksmithing skill you get for crafting this recipe
	var/exp_gain = 10
	/// Amount of time it takes to smelt its contents. This times 2 if there's no flux so it has to be a reasonable amount
	var/smelting_time = 30 SECONDS

/// Returns amount of this item needed for this recipe if the item is in reqs, otherwise returns null
/datum/alloy_recipe/proc/can_accept_item(obj/item/I, list/contents)
	. = null

	if(!(I.type in reqs) || !((I.materials && (I.materials in req_materials)) || (!I.materials && ("null" in req_materials))))
		return null

	for(var/obj/item/CI in contents)
		if(!((CI.materials && (CI.materials in req_materials)) || (!CI.materials && ("null" in req_materials))) || !(CI.type in reqs))
			return null

	for(var/i in 1 to reqs.len)
		var/req_type = reqs[i]
		var/req_material = req_materials[i]
		var/req_amount = req_materials[req_material]
		var/existing_amount = 0

		if(I.type != req_type || !((I.materials == req_material && !istext(req_material)) || (isnull(I.materials) && istext(req_material))))
			continue

		for(var/obj/item/CI in contents)
			if(CI.type == req_type && ((CI.materials == req_material && !istext(req_material)) || (isnull(CI.materials) && istext(req_material))))
				if(isstack(CI))
					var/obj/item/stack/CS = CI
					existing_amount += CS.amount
				else
					existing_amount++
		return (req_amount - existing_amount)

/// Returns TRUE if the contents perfectly match the requirements, otherwise returns FALSE
/datum/alloy_recipe/proc/are_reqs_fulfilled(list/contents)
	. = TRUE
	for(var/i in 1 to reqs.len)
		var/req_type = reqs[i]
		var/req_material = req_materials[i]
		var/req_amount = req_materials[req_material]
		var/existing_amount = 0

		for(var/obj/item/CI in contents)
			if(!(CI.type in reqs))
				return null
			if(CI.type == req_type && ((CI.materials == req_material && !istext(req_material)) || (isnull(CI.materials) && istext(req_material))))
				if(isstack(CI))
					var/obj/item/stack/CS = CI
					existing_amount += CS.amount
				else
					existing_amount++

		if(existing_amount != req_amount)
			return FALSE

/*************************************************************************/
/*                           List of alloy recipes                       */
/*************************************************************************/

/datum/alloy_recipe/pig_iron
	result_material = /datum/material/pig_iron
	result_amount = 1
	reqs = list(/obj/item/ingot, /obj/item/stack/ore/coal)
	req_materials = list(/datum/material/iron=1, null=5)
	exp_gain = 35

/datum/alloy_recipe/bronze
	result_material = /datum/material/bronze
	result_amount = 2
	reqs = list(/obj/item/ingot, /obj/item/ingot)
	req_materials = list(/datum/material/copper=1, /datum/material/tin=1)
	exp_gain = 20
