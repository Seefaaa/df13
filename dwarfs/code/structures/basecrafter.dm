/// Base class for crafting tables. All of them behave similarly so here we are
/obj/structure/crafter
	name = "basic crafter"
	desc = "If you see this, yell at coders."
	anchored = TRUE
	/// Is somebody interacting with src?
	var/busy = FALSE
	/// Is the recipe ready to be assembled
	var/ready = FALSE
	/// Current selected recipe
	var/datum/crafter_recipe/selected_recipe
	/// What recipe subtypes do we use?
	var/used_recipe_type = /datum/crafter_recipe
	/// What sound is played when a player crafts something
	var/craft_sound = 'dwarfs/sounds/tools/anvil/anvil_hit.ogg'

/// Returns highest grade among all items in the contents
/obj/structure/crafter/proc/get_highest_grade()
	. = 1
	for(var/obj/I in contents)
		if(I.grade > .)
			. = I.grade

/// Return TRUE/FALSE depending whether the selected recipe requires that item
/obj/structure/crafter/proc/is_item_required(obj/item/I)
	. = FALSE
	for(var/O in selected_recipe.reqs)
		if(istype(I, O))
			return TRUE

/// Check if there are enough items for the assembly, updates the `ready` var and returns the result
/obj/structure/crafter/proc/check_ready()
	. = TRUE
	for(var/type in selected_recipe.reqs)
		if((selected_recipe.reqs[type] - type_amount(type)) > 0)
			. = FALSE
			break
	ready = .

/// Returns an obj inside src by type if there is one, otherwise null
/obj/structure/crafter/proc/get_item_by_type(item_type)
	for(var/obj/O in contents)
		if(istype(O, item_type))
			return O
	return null

/// Returns amount of items inside src by item type
/obj/structure/crafter/proc/type_amount(type)
	. = 0
	for(var/obj/item/I in contents)
		if(istype(I, type))
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				.+=S.amount
			else
				.++

/obj/structure/crafter/examine(mob/user)
	. = ..()
	if(selected_recipe)
		.+="<br>Currenly [selected_recipe.name] is assembled."
		if(!ready)
			var/text = "<br>Required:"
			for(var/type in selected_recipe.reqs)
				var/obj/O = type
				var/amount = selected_recipe.reqs[O]
				if(amount - type_amount(O))
					text += "<br>[amount - type_amount(O)] [initial(O.name)]"
			.+=text
		else
			.+="<hr>[capitalize(selected_recipe)] is ready to be assembled."
	else
		.+="<br>[src] is empty!"

/obj/structure/crafter/attack_hand(mob/user)
	if(busy)
		to_chat(user, span_warning("Somebody is already using [src]."))
	else if(ready)
		busy = TRUE
		to_chat(user, span_notice("You start assembling [selected_recipe]..."))
		var/channel = playsound(src, craft_sound, 60, TRUE)
		var/assembly_time = selected_recipe.crafting_time
		if(selected_recipe.affecting_skill)
			assembly_time *= user.get_skill_modifier(selected_recipe.affecting_skill, SKILL_SPEED_MODIFIER)
		if(!do_after(user, assembly_time, src))
			busy = FALSE
			stop_sound_channel_nearby(src, channel)
			return
		stop_sound_channel_nearby(src, channel)
		var/list/_materials = list()
		var/obj/O
		for(var/obj/I in contents)
			if(!I.materials)
				continue
			_materials[I.part_name] = I.materials
		// if we have only one component, we just use that material, no need for a part list
		if(_materials.len == 1)
			var/part_name = _materials[1]
			_materials = _materials[part_name]
		for(var/i in 1 to selected_recipe.result_amount)
			O = new selected_recipe.result(loc)
			O.apply_material(_materials)
			O.update_stats(get_highest_grade())
		if(selected_recipe.affecting_skill)
			user.adjust_experience(selected_recipe.affecting_skill, selected_recipe.exp_gain)
		to_chat(user, span_notice("You assemble \a [O]."))
		QDEL_NULL(selected_recipe)
		contents.Cut()
		update_appearance()
		ready = FALSE
		busy = FALSE
	else if(selected_recipe && contents.len)
		var/answer = tgui_alert(user, "Cancel current assembly?", capitalize(name), list("Yes", "No"))
		if(answer != "Yes" || !answer)
			return
		for(var/I in contents)
			var/atom/movable/M = I
			M.forceMove(drop_location())
		to_chat(user, span_notice("You cancel the assembly of [selected_recipe]."))
		QDEL_NULL(selected_recipe)
		update_appearance()
	else
		var/list/recipes = list()
		for(var/t in subtypesof(used_recipe_type))
			var/datum/crafter_recipe/recipe_type = t
			var/recipe_name = initial(recipe_type.name)
			recipes[recipe_name] = recipe_type
		var/answer = tgui_input_list(user, "What to assemble?", capitalize(name), recipes)
		if(!answer)
			return
		var/selected_type = recipes[answer]
		selected_recipe = new selected_type
		to_chat(user, span_notice("You select [selected_recipe.name] for assembly."))

/obj/structure/crafter/attackby(obj/item/I, mob/user, params)
	if(user.a_intent == INTENT_HARM || !selected_recipe)
		return ..()
	else if(is_item_required(I))
		if((selected_recipe.reqs[I.type] - type_amount(I.type)) > 0)
			var/obj/existing_obj = get_item_by_type(I.type)
			if(existing_obj && existing_obj.materials != I.materials)
				to_chat(user, span_warning("You have to use [existing_obj.name] made from [get_material_name(existing_obj.materials)]."))
				return
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				S.use(1)
				var/added = FALSE
				for(var/obj/item/stack/O in locate(I.type) in contents)
					O.amount++
					added = TRUE
					break
				if(!added)
					var/obj/O = new S.type(src)
					O.apply_material(I.materials)
			else
				I.forceMove(src)
			user.visible_message(span_notice("[user] places [I] on \the [src]."), span_notice("You place [I] on \the [src]."))
			check_ready()
			update_appearance()
		else
			to_chat(user, span_warning("There is enough of [I.name]."))
	else
		return ..()
