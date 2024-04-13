/mob/living/simple_animal/hostile/undead
	name = "undead skeleton"
	desc = "Walking pile of bones."
	icon = 'dwarfs/icons/mob/undead/undead.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "husk"
	gender = NEUTER
	speak_chance = 0
	turns_per_move = 2
	speed = 2
	maxHealth = 100
	health = 100
	loot = list(/obj/effect/decal/remains/human)
	faction = list("undead")
	weather_immunities = list("lava","ash")
	melee_damage_lower = 5
	melee_damage_upper = 10
	unique_name = TRUE
	minbodytemp = -INFINITY
	maxbodytemp = INFINITY
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	del_on_death = 1
	deathsound = 'dwarfs/sounds/mobs/undead/skeleton_death_01.ogg'
	deathmessage = "falls to the ground, as its bones shatter to pieces!"
	var/mob/living/master
	var/obj/item/magicstaff/necromant/masterstaff

/mob/living/simple_animal/hostile/undead/Initialize()
	. = ..()
	maxHealth = rand(85, 125)
	health = maxHealth
	if(icon_living == "skeleton")
		flick("skeleton_rise", src)
	gear_up()

/mob/living/simple_animal/hostile/undead/death(gibbed)
	. = ..()
	if(masterstaff)
		masterstaff.controlled -= src

/mob/living/simple_animal/hostile/undead/proc/gear_up()
	var/obj/item/clothing/helmet = pick(
		5; /obj/item/clothing/head/heavy_plate,
		25; /obj/item/clothing/head/light_plate,
		10; /obj/item/reagent_containers/glass/bucket,
		10; /obj/item/stack/sheet/animalhide/bear,
		50; null)
	if(helmet)
		var/icon/I_h = create_material_icon(helmet, 'dwarfs/icons/mob/undead/undead_clothing.dmi', helmet::worn_icon_state, helmet::materials)
		mutable_appearance()
		add_overlay(I_h)

	var/obj/item/clothing/chest = pick(
		15; /obj/item/clothing/under/chainmail,
		35; /obj/item/clothing/under/tunic,
		50; null)
	if(chest)
		var/icon/I_c = create_material_icon(chest, 'dwarfs/icons/mob/undead/undead_clothing.dmi', chest::worn_icon_state, chest::materials)
		add_overlay(I_c)

	var/obj/item/clothing/shoes = pick(
		25; /obj/item/clothing/shoes/plate_boots,
		25; /obj/item/clothing/shoes/boots,
		50; null)
	if(shoes)
		var/icon/I_s = create_material_icon(shoes, 'dwarfs/icons/mob/undead/undead_clothing.dmi', shoes::worn_icon_state, shoes::materials)
		add_overlay(I_s)

/mob/living/simple_animal/hostile/undead/zombie
	name = "undead zombie"
	desc = "A walking pile of rotting mass."
	icon_state = "zombie"
	icon_living = "zombie"
	deathmessage = "falls to the ground and crumbles into dark ashes!"

/mob/living/simple_animal/hostile/undead/zombie/Initialize()
	. = ..()
	var/variation = pick("zombie", "husk")
	icon_state = variation
	icon_living = variation

/mob/living/simple_animal/hostile/undead/zombie/examine(mob/user)
	. = ..()
	if(get_dist(user, src) < 3)
		. += " It smells awful."
