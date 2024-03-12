/mob/living/carbon/human/verb/recipes()
	set name = "📘 Cooking Recipes"
	set category = "IC"
	set desc = "View your character's known recipes."
	if(mind)
		mind.show_recipes(src)
	else
		to_chat(src, "You don't have a mind datum for some reason, so you can't look at your recipes, if you had any.")

/datum/mind/proc/show_recipes(mob/user)
	if(!user)
		user = current

	var/datum/skill/S = user.get_skill(/datum/skill/cooking)
	var/skill_level = S ? S.level : 1
	var/text = ""
	for(var/t in GLOB.cooking_recipes)
		var/datum/cooking_recipe/recipe = GLOB.cooking_recipes[t]
		if(!recipe.result)
			continue
		var/recipe_name = initial(recipe.result.name)
		var/obj/result = new recipe.result
		if(recipe.req_lvl <= skill_level)
			var/image_path = icon2path(result.get_material_icon(result.icon, result.icon_state), user)
			text += "<br><font color=green><img class='dish-image' src=[image_path]><b>[recipe_name]:</b></font>"
			for(var/item in recipe.req_items)
				var/obj/item/I = item
				text += "<br>[FOURSPACES]&#8226 [recipe.req_items[item]] [initial(I.name)]"
			for(var/reag in recipe.req_reagents)
				var/datum/reagent/R = reag
				text += "<br>[FOURSPACES]&#8226 [recipe.req_reagents[reag]] [initial(R.name)]"
			text += "<br>[FOURSPACES][recipe.cooking_text]"
			text += "<hr>"
		qdel(result)
	var/datum/browser/recipe_window = new(user, "recipe_window")
	recipe_window.set_content(text)
	recipe_window.add_stylesheet("font-awesome", 'html/font-awesome/css/all.min.css')
	recipe_window.add_stylesheet("recipe-window", 'html/browser/recipe_window.css')
	recipe_window.width = 500
	recipe_window.height = 600
	recipe_window.title = "Known Recipes"
	recipe_window.open(FALSE)
