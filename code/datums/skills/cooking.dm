/datum/skill/cooking
	name = "Cooking"
	title = "Chef"
	desc = "The art of cooking dishes."
	modifiers = list(
		SKILL_SPEED_MODIFIER=list(3,2.5,2,1.5,1.2,1,1,0.9,0.8,0.7,0.6),//How fast are we doing cooking related stuff
		SKILL_AMOUNT_MIN_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3),//+This to the base min amount
		SKILL_AMOUNT_MAX_MODIFIER=list(-1,0,0,0,1,1,1,1,2,2,3)//+This to the base max amount
	)

/datum/skill/cooking/level_gained(mob/user, new_level, old_level, silent)
	. = ..()
	if(!silent)
		to_chat(user, span_green("Through better understanding of [name] I realise how to cook new recipes!"))

/datum/mind/proc/show_recipes(mob/user)
	if(!user)
		user = current

	var/datum/skill/S = user.get_skill(/datum/skill/cooking)
	var/skill_level = S ? S.level : 1
	var/text = ""
	text += "<center><b>Cooking Recipes</b></center>"
	for(var/t in GLOB.cooking_recipes)
		var/datum/cooking_recipe/recipe = GLOB.cooking_recipes[t]
		var/recipe_name = initial(recipe.result.name)
		if(recipe.req_lvl <= skill_level)
			var/image_path = icon2path(initial(recipe.result.icon), user, initial(recipe.result.icon_state))
			text += "<br><font color=green><img src=[image_path]>[recipe_name]:</font>"
			for(var/item in recipe.req_items)
				var/obj/item/I = item
				text += "<br>[FOURSPACES][recipe.req_items[item]] [initial(I.name)]"
			for(var/reag in recipe.req_reagents)
				var/datum/reagent/R = reag
				text += "<br>[FOURSPACES][recipe.req_reagents[reag]] [initial(R.name)]"
			text += "<br>[FOURSPACES][recipe.cooking_text]"
			text += "<br>"
	var/datum/browser/recipe_window = new(user, "recipe_window")
	recipe_window.set_content(text)
	recipe_window.add_stylesheet("font-awesome", 'html/font-awesome/css/all.min.css') //TODO: add custom stylesheet
	recipe_window.width = 500
	recipe_window.height = 300
	recipe_window.title = "Known Recipes"
	recipe_window.open(FALSE)
