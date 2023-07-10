/mob/living/carbon/human/verb/recipes()
	set name = "📘 Cooking Recipes"
	set category = "IC"
	set desc = "View your character's known recipes."
	if(mind)
		mind.show_recipes(src)
	else
		to_chat(src, "You don't have a mind datum for some reason, so you can't look at your recipes, if you had any.")
