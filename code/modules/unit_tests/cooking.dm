/datum/unit_test/oven/Run()
	var/mob/living/carbon/human/chef = allocate(/mob/living/carbon/human)
	var/obj/structure/oven/oven = allocate(/obj/structure/oven)
	var/obj/item/reagent_containers/glass/cake_pan/cake_pan = allocate(/obj/item/reagent_containers/glass/cake_pan)

	oven.fuel = 1
	oven.fuel_consumption = 0
	oven.cooking_time = 0
	oven.working = TRUE

	new/obj/item/food/dough(cake_pan)
	new/obj/item/growable/apple(cake_pan)
	new/obj/item/growable/apple(cake_pan)
	new/obj/item/growable/apple(cake_pan)

	chef.put_in_hands(cake_pan)
	oven.attackby(cake_pan, chef)

	sleep(5)

	var/obj/item/resulting = locate(/obj/item) in get_turf(oven)
	var/exp = chef.get_skill_exp(/datum/skill/cooking)

	TEST_ASSERT(resulting, "Cooking did not spawn any resulting item")
	TEST_ASSERT(istype(resulting, /obj/item/transfer_food/cake/apple_pie), "Cooking resulted in wrong item spawn. Expected: /obj/item/transfer_food/cake/apple_pie Spawned: [resulting.type]")
	TEST_ASSERT(exp > 0, "Chef did not get any experience")

	var/obj/item/reagent_containers/glass/cake_pan/ruined_pan = allocate(/obj/item/reagent_containers/glass/cake_pan)

	new/obj/item/growable/apple(ruined_pan)

	chef.put_in_hands(ruined_pan)
	oven.attackby(ruined_pan, chef)

	sleep(5)

	var/obj/badrecipe = locate(/obj/item/food/badrecipe) in get_turf(oven)
	var/obj/container = locate(/obj/item/reagent_containers/glass/cake_pan) in get_turf(oven)

	TEST_ASSERT(badrecipe, "Cooking did not spawn badrecipe food")
	TEST_ASSERT(container, "Cooking badrecipe did not return the original container")
	TEST_ASSERT(chef.get_skill_exp(/datum/skill/cooking) > exp, "Chef did not get any experience")

/datum/unit_test/stove/Run()
	var/mob/living/carbon/human/chef = allocate(/mob/living/carbon/human)
	var/obj/structure/stove/stove = allocate(/obj/structure/stove)
	var/obj/item/reagent_containers/glass/cooking_pot/cooking_pot = allocate(/obj/item/reagent_containers/glass/cooking_pot)

	stove.fuel = 1
	stove.fuel_consumption = 0
	stove.cook_time = 0
	stove.working = TRUE

	new/obj/item/growable/onion(cooking_pot)
	new/obj/item/growable/carrot(cooking_pot)
	new/obj/item/growable/carrot(cooking_pot)
	new/obj/item/growable/turnip(cooking_pot)
	cooking_pot.reagents.add_reagent(/datum/reagent/water, 15)

	chef.put_in_hands(cooking_pot)
	stove.attackby(cooking_pot, chef)

	sleep(5)

	var/obj/item/resulting = locate(/obj/item) in get_turf(stove)
	var/exp = chef.get_skill_exp(/datum/skill/cooking)

	TEST_ASSERT(resulting, "Cooking did not spawn any resulting item")
	TEST_ASSERT(istype(resulting, /obj/item/transfer_food/pot/veggie_stew), "Cooking resulted in wrong item spawn. Expected: /obj/item/transfer_food/pot/veggie_stew Spawned: [resulting.type]")
	TEST_ASSERT(exp > 0, "Chef did not get any experience")

	qdel(resulting)

	var/obj/item/reagent_containers/glass/cooking_pot/ruined_pot = allocate(/obj/item/reagent_containers/glass/cooking_pot)

	new/obj/item/growable/apple(ruined_pot)

	chef.put_in_hands(ruined_pot)
	stove.attackby(ruined_pot, chef)

	sleep(5)

	var/obj/badrecipe = locate(/obj/item/food/badrecipe) in get_turf(stove)
	var/obj/container = locate(/obj/item/reagent_containers/glass/cooking_pot) in get_turf(stove)

	TEST_ASSERT(badrecipe, "Cooking did not spawn badrecipe food")
	TEST_ASSERT(!istype(container), "Cooking badrecipe returned the original container")
	TEST_ASSERT(stove.left_item, "Cooking badrecipe removed the original container")
	TEST_ASSERT(chef.get_skill_exp(/datum/skill/cooking) > exp, "Chef did not get any experience")

	qdel(badrecipe)

	var/obj/item/reagent_containers/glass/pan/pan = allocate(/obj/item/reagent_containers/glass/pan)

	new/obj/item/food/egg(pan)
	new/obj/item/food/egg(pan)
	new/obj/item/food/meat/slab(pan)

	chef.put_in_hands(pan)
	stove.attackby_secondary(pan, chef)

	sleep(5)

	resulting = locate(/obj/item) in get_turf(stove)

	TEST_ASSERT(resulting, "Cooking did not spawn any resulting item")
	TEST_ASSERT(istype(resulting, /obj/item/transfer_food/skillet/egg_steak), "Cooking resulted in wrong item spawn. Expected: /obj/item/transfer_food/skillet/egg_steak Spawned: [resulting.type]")
	TEST_ASSERT(chef.get_skill_exp(/datum/skill/cooking) > exp, "Chef did not get any experience")

	exp = chef.get_skill_exp(/datum/skill/cooking)

	var/obj/item/reagent_containers/glass/pan/ruined_pan = allocate(/obj/item/reagent_containers/glass/pan)

	new/obj/item/growable/apple(ruined_pan)

	chef.put_in_hands(ruined_pan)
	stove.attackby_secondary(ruined_pan, chef)

	sleep(5)

	badrecipe = locate(/obj/item/food/badrecipe) in get_turf(stove)
	container = locate(/obj/item/reagent_containers/glass/pan) in get_turf(stove)

	TEST_ASSERT(badrecipe, "Cooking did not spawn badrecipe food")
	TEST_ASSERT(!istype(container), "Cooking badrecipe returned the original container")
	TEST_ASSERT(stove.left_item, "Cooking badrecipe removed the original container")
	TEST_ASSERT(chef.get_skill_exp(/datum/skill/cooking) > exp, "Chef did not get any experience")


/datum/unit_test/bowl/Run()
	var/mob/living/carbon/human/chef = allocate(/mob/living/carbon/human)
	var/obj/item/knife = allocate(/obj/item/kitchen/knife)
	var/obj/item/bowl = allocate(/obj/item/reagent_containers/glass/plate/bowl)

	new/obj/item/growable/carrot(bowl)
	new/obj/item/growable/plump_helmet(bowl)
	new/obj/item/growable/turnip(bowl)

	chef.put_in_hands(knife)
	chef.put_in_hands(bowl)

	bowl.attackby(knife, chef)

	var/obj/item/resulting = chef.is_holding_item_of_type(/obj/item/food/dish/salad)
	var/exp = chef.get_skill_exp(/datum/skill/cooking)

	TEST_ASSERT(resulting, "Cooking did not spawn any resulting item")
	TEST_ASSERT(exp > 0, "Chef did not get any experience")

	qdel(resulting)

	var/obj/item/failed_bowl = allocate(/obj/item/reagent_containers/glass/plate/bowl)

	new/obj/item/growable/turnip(bowl)

	chef.put_in_hands(failed_bowl)

	failed_bowl.attackby(knife, chef)

	TEST_ASSERT(chef.is_holding_item_of_type(/obj/item/reagent_containers/glass/plate/bowl), "Cooking badrecipe deleted original container")
	TEST_ASSERT(locate(/obj/item/food/badrecipe) in get_turf(chef), "Cooking badrecipe didn't spawn badrecipe food")
	TEST_ASSERT(chef.get_skill_exp(/datum/skill/cooking) > exp, "Chef did not get any experience")

/datum/unit_test/stick/Run()
	var/mob/living/carbon/human/chef = allocate(/mob/living/carbon/human)
	var/obj/item/flashlight/lantern = allocate(/obj/item/flashlight/fueled/lantern)
	var/obj/item/stick = allocate(/obj/item/stick)

	new/obj/item/growable/plump_helmet(stick)
	new/obj/item/growable/plump_helmet(stick)
	new/obj/item/growable/plump_helmet(stick)

	chef.put_in_hands(lantern)
	chef.put_in_hands(stick)

	lantern.attack_self(chef)
	stick.attackby(lantern, chef)

	var/obj/item/resulting = chef.is_holding_item_of_type(/obj/item/food/dish/plump_skewer)
	var/exp = chef.get_skill_exp(/datum/skill/cooking)

	TEST_ASSERT(resulting, "Cooking did not spawn any resulting item")
	TEST_ASSERT(exp > 0, "Chef did not get any experience")

	qdel(resulting)

	var/obj/item/failed_stick = allocate(/obj/item/stick)

	new/obj/item/growable/turnip(failed_stick)

	chef.put_in_hands(failed_stick)

	failed_stick.attackby(lantern, chef)

	TEST_ASSERT(chef.is_holding_item_of_type(/obj/item/stick), "Cooking badrecipe deleted original container")
	TEST_ASSERT(locate(/obj/item/food/badrecipe) in get_turf(chef), "Cooking badrecipe didn't spawn badrecipe food")
	TEST_ASSERT(chef.get_skill_exp(/datum/skill/cooking) > exp, "Chef did not get any experience")
