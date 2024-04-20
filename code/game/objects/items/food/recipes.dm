GLOBAL_LIST_EMPTY(cooking_recipes)

/proc/build_cooking_recipes()
	for(var/recipe in subtypesof(/datum/cooking_recipe))
		var/datum/cooking_recipe/C = new recipe
		GLOB.cooking_recipes[recipe] = C

/datum/cooking_recipe
	/// Required item ingredients
	var/list/req_items = list()
	/// Required reagent ingredients
	var/list/req_reagents = list()
	/// What does this recipe spawn? Usually something from /obj/item/food/dish/...
	var/obj/result
	/// What cooking level is required to add this recipe to notes
	var/req_lvl = 12
	/// Explanation text included in recipe list
	var/cooking_text = "Tell admins about me."
	/// Do we delete original container it was cooked in?
	var/consume_container = TRUE
	/// Exp gain when made
	var/exp_gain = 10
	/// Whether to show a recipe in recipe list
	var/visible_in_list = TRUE

///******************RUINED RECIPES******************///

/datum/cooking_recipe/ruined_dish
	result = /obj/item/food/badrecipe
	visible_in_list = FALSE
	consume_container = FALSE
	exp_gain = 4

/datum/cooking_recipe/ruined_sausage
	result = /obj/item/food/sausage/failed
	visible_in_list = FALSE
	exp_gain = 4

///******************OVEN RECIPES******************///
/datum/cooking_recipe/oven
/datum/cooking_recipe/oven/sheet
/datum/cooking_recipe/oven/cake

/datum/cooking_recipe/oven/sheet/baked_potato
	req_items = list(/obj/item/growable/potato=4)
	result = /obj/item/transfer_food/sheet/baked_potato
	req_lvl = 2
	cooking_text = "Place everything on the baking sheet and bake it in the oven."
	exp_gain = 15

/datum/cooking_recipe/oven/cake/plump_quiche
	req_items = list(/obj/item/food/slice/cheese=3, /obj/item/food/slice/plump_helmet=3, /obj/item/food/dough=1)
	result = /obj/item/transfer_food/cake/plump_pie
	req_lvl = 6
	cooking_text = "Place everything in the cake pan and bake it in the oven."
	exp_gain = 55

/datum/cooking_recipe/oven/cake/meat_quiche
	req_items = list(/obj/item/food/slice/cheese=3, /obj/item/food/slice/meat=3, /obj/item/food/dough=1)
	result = /obj/item/transfer_food/cake/meat_quiche
	req_lvl = 6
	cooking_text = "Place everything in the cake pan and bake it in the oven."
	exp_gain = 60

/datum/cooking_recipe/oven/cake/plump_pie
	req_items = list(/obj/item/food/dough=1, /obj/item/growable/plump_helmet=3, /obj/item/growable/sweet_pod=2)
	result = /obj/item/transfer_food/cake/plump_pie
	req_lvl = 4
	cooking_text = "Place everything in the cake pan and bake it in the oven."
	exp_gain = 40

/datum/cooking_recipe/oven/cake/meat_pie
	req_items = list(/obj/item/food/dough=1, /obj/item/food/slice/meat=2, /obj/item/growable/onion=1)
	result = /obj/item/transfer_food/cake/meat_pie
	req_lvl = 3
	cooking_text = "Place everything in the cake pan and bake it in the oven."
	exp_gain = 50

/datum/cooking_recipe/oven/cake/apple_pie
	req_items = list(/obj/item/food/dough=1, /obj/item/growable/apple=3)
	result = /obj/item/transfer_food/cake/apple_pie
	req_lvl = 4
	cooking_text = "Place everything in the cake pan and bake it in the oven."
	exp_gain = 36

/datum/cooking_recipe/oven/sheet/balanced_roll
	req_items = list(/obj/item/food/flat_dough=2, /obj/item/food/slice/meat/chicken=3, /obj/item/growable/carrot=2, /obj/item/food/slice/plump_helmet=2)
	result = /obj/item/transfer_food/sheet/roll
	req_lvl = 6
	cooking_text = "Place everything on the baking sheet and bake it in the oven."
	exp_gain = 40

/datum/cooking_recipe/oven/sheet/bread
	req_items = list(/obj/item/food/dough=2)
	result = /obj/item/transfer_food/sheet/bread
	req_lvl = 6
	cooking_text = "Place everything on the baking sheet and bake it in the oven."
	exp_gain = 24

/datum/cooking_recipe/oven/sheet/trolls_delight
	req_items = list(/obj/item/food/meat/slab/troll=2, /obj/item/food/slice/plump_helmet=3, /obj/item/growable/carrot=1)
	req_reagents = list(/datum/reagent/consumable/juice/sweet_pod=10)
	result = /obj/item/transfer_food/sheet/troll_delight
	req_lvl = 7
	cooking_text = "Place everything on the baking sheet and bake it in the oven."
	exp_gain = 70

///******************POT RECIPES******************///
/datum/cooking_recipe/pot

/datum/cooking_recipe/pot/cooked_egg
	req_items = list(/obj/item/food/egg=4)
	req_reagents = list(/datum/reagent/water=15)
	result = /obj/item/transfer_food/pot/cooked_egg
	req_lvl = 2
	cooking_text = "Put everything in a pot and cook on the stove."
	exp_gain = 14

/datum/cooking_recipe/pot/plump_stew
	req_items = list(/obj/item/food/slice/meat=3, /obj/item/growable/plump_helmet=2, /obj/item/growable/turnip=1)
	req_reagents = list(/datum/reagent/water=15)
	result = /obj/item/transfer_food/pot/plump_stew
	req_lvl = 3
	cooking_text = "Put everything in a pot and cook on the stove."
	exp_gain = 27

/datum/cooking_recipe/pot/veggie_stew
	req_items = list(/obj/item/growable/onion=1, /obj/item/growable/carrot=2, /obj/item/growable/turnip=1)
	req_reagents = list(/datum/reagent/water=15)
	result = /obj/item/transfer_food/pot/veggie_stew
	req_lvl = 3
	cooking_text = "Put everything in a pot and cook on the stove."
	exp_gain = 25

/datum/cooking_recipe/pot/carrot_soup
	req_items = list(/obj/item/growable/onion=1, /obj/item/growable/carrot=3)
	req_reagents = list(/datum/reagent/water=20)
	result = /obj/item/transfer_food/pot/carrot_soup
	req_lvl = 4
	cooking_text = "Put everything in a pot and cook on the stove."
	exp_gain = 23

/datum/cooking_recipe/pot/potato_soup
	req_items = list(/obj/item/growable/onion=1, /obj/item/growable/potato=3)
	req_reagents = list(/datum/reagent/water=20)
	result = /obj/item/transfer_food/pot/potato_soup
	req_lvl = 4
	cooking_text = "Put everything in a pot and cook on the stove."
	exp_gain = 23

/datum/cooking_recipe/pot/plump_soup
	req_items = list(/obj/item/growable/onion=1, /obj/item/growable/plump_helmet=3)
	req_reagents = list(/datum/reagent/water=20)
	result = /obj/item/transfer_food/pot/plump_soup
	req_lvl = 4
	cooking_text = "Put everything in a pot and cook on the stove."
	exp_gain = 33

///******************PLATE RECIPES******************///
/datum/cooking_recipe/plate

///******************STICK RECIPES******************///
/datum/cooking_recipe/stick

/datum/cooking_recipe/stick/plump_skewer
	req_items = list(/obj/item/growable/plump_helmet=3)
	result = /obj/item/food/dish/plump_skewer
	req_lvl = 2
	cooking_text = "Insert all of it onto a stick and apply some fire."
	exp_gain = 14

/datum/cooking_recipe/stick/meat_skewer
	req_items = list(/obj/item/food/slice/meat=4)
	result = /obj/item/food/dish/meat_skewer
	req_lvl = 2
	cooking_text = "Insert all of it onto a stick and apply some fire."
	exp_gain = 18

/datum/cooking_recipe/stick/balanced_skewer
	req_items = list(/obj/item/food/slice/meat=2, /obj/item/growable/carrot=1, /obj/item/growable/turnip=1)
	result = /obj/item/food/dish/balanced_skewer
	req_lvl = 2
	cooking_text = "Insert all of it onto a stick and apply some fire."
	exp_gain = 19

///******************BOWL RECIPES******************///
/datum/cooking_recipe/bowl

/datum/cooking_recipe/bowl/veggie_salad
	req_items = list(/obj/item/growable/carrot=1, /obj/item/growable/plump_helmet=1, /obj/item/growable/turnip=1)
	result = /obj/item/food/dish/salad
	req_lvl = 2
	cooking_text = "Throw everything into a bowl and mix with a kitchen knife."
	exp_gain = 15

/datum/cooking_recipe/bowl/potato_salad
	req_items = list(/obj/item/growable/potato=3, /obj/item/growable/onion=1)
	req_reagents = list(/datum/reagent/consumable/vinegar=5)
	result = /obj/item/food/dish/potato_salad
	req_lvl = 2
	cooking_text = "Throw everything into a bowl and mix with a kitchen knife."
	exp_gain = 18

///******************PAN RECIPES******************///
/datum/cooking_recipe/pan

/datum/cooking_recipe/pan/plump_steak
	req_items = list(/obj/item/food/slice/plump_helmet=3, /obj/item/food/meat/slab=1)
	result = /obj/item/transfer_food/skillet/plump_steak
	req_lvl = 2
	cooking_text = "Prepare everything on a pan and roast at a stove."
	exp_gain = 20

/datum/cooking_recipe/pan/beer_wurst
	req_items = list(/obj/item/food/sausage=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/cave_wheat=10)
	result = /obj/item/transfer_food/skillet/beer_wurst
	req_lvl = 5
	cooking_text = "Prepare everything on a pan and roast at a stove."
	exp_gain = 24

/datum/cooking_recipe/pan/egg_steak
	req_items = list(/obj/item/food/egg=2, /obj/item/food/meat/slab=1)
	result = /obj/item/transfer_food/skillet/egg_steak
	req_lvl = 3
	cooking_text = "Prepare everything on a pan and roast at a stove."
	exp_gain = 28

/datum/cooking_recipe/pan/allwurst
	req_items = list(/obj/item/food/sausage/luxurious=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/cave_wheat=10)
	result = /obj/item/transfer_food/skillet/allwurst
	req_lvl = 7
	cooking_text = "Prepare everything on a pan and roast at a stove."
	exp_gain = 32

/datum/cooking_recipe/pan/beer_wurst_alternative
	req_items = list(/obj/item/food/sausage=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/barley=10)
	result = /obj/item/transfer_food/skillet/beer_wurst
	req_lvl = 5
	cooking_text = "Prepare everything on a pan and roast at a stove."
	exp_gain = 24

/datum/cooking_recipe/pan/allwurst_alternative
	req_items = list(/obj/item/food/sausage/luxurious=1)
	req_reagents = list(/datum/reagent/consumable/ethanol/beer/barley=10)
	result = /obj/item/transfer_food/skillet/allwurst
	req_lvl = 7
	cooking_text = "Prepare everything on a pan and roast at a stove."
	exp_gain = 32

///******************SAUSAGE RECIPES******************///
/datum/cooking_recipe/sausage

/datum/cooking_recipe/sausage/regular
	req_items = list(/obj/item/food/slice/meat=2)
	result = /obj/item/food/sausage
	req_lvl = 5
	cooking_text = "Throw everything into casings and tie them up."
	exp_gain = 11

/datum/cooking_recipe/sausage/luxurious
	req_items = list(/obj/item/food/slice/meat/troll=1, /obj/item/food/slice/meat=2, /obj/item/growable/carrot=1, /obj/item/growable/plump_helmet=1)
	result = /obj/item/food/sausage/luxurious
	req_lvl = 7
	cooking_text = "Throw everything into casings and tie them up."
	exp_gain = 21

///Returns either null if no plausable candidates found or a recipe /datum/cooking_recipe/...
/proc/find_recipe(list/_recipes=list(), list/_contents=list(), list/_reagents=list(), failed_recipe=/datum/cooking_recipe/ruined_dish)
	var/list/recipes = list()
	for(var/R in _recipes)
		var/datum/cooking_recipe/C = GLOB.cooking_recipes[R]
		recipes.Add(C)

	if(!recipes.len || (!_contents.len && !_reagents)) // sanity check
		return

	//typelists with amount of specified type
	var/list/contents = list()
	var/list/reagents = list()

	// count amount of each item type
	for(var/obj/O in _contents)
		if(!contents[O.type])
			contents[O.type] = 1
		else
			contents[O.type]++
	// same with reagent types
	for(var/datum/reagent/R in _reagents)
		reagents[R.type] = R.volume

	var/list/recipe_matches_items = list()
	var/list/recipe_matches_reagents = list()

	for(var/datum/cooking_recipe/_recipe in recipes)
		recipe_matches_items[_recipe.type] = list()
		recipe_matches_reagents[_recipe.type] = list()

	// check for each recipe amount of matched reagents and remember the total amount
	for(var/datum/cooking_recipe/recipe in recipes)
		for(var/O in contents)
			var/amt = contents[O]
			if(O in recipe.req_items)
				recipe_matches_items[recipe.type][O] = amt

		for(var/R in reagents)
			var/vol = reagents[R]
			if(R in recipe.req_reagents)
				recipe_matches_reagents[recipe.type][R] = vol

	// search for perfect match
	for(var/datum/cooking_recipe/recipe in recipes.Copy())
		var/i_p = 1
		var/r_p = 1
		if(recipe.req_items.len)
			var/matched = 0
			for(var/O in recipe.req_items)
				matched += recipe_matches_items[recipe.type][O]/recipe.req_items[O]
			i_p = round(matched/recipe.req_items.len, 0.01)
		if(recipe.req_reagents.len)
			var/matched = 0
			for(var/R in recipe.req_reagents)
				matched += recipe_matches_reagents[recipe.type][R]/recipe.req_reagents[R]
			r_p = round(matched/recipe.req_reagents.len, 0.01)

		if(i_p == 1 && r_p == 1)
			return recipe
	return GLOB.cooking_recipes[failed_recipe]
