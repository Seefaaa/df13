/obj/item/magicstaff
	name = "Magic scrap"
	desc = "Useless piece of magic scrap, unless you know what's it for."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "king_scepter"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "king_scepter"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	force = 5
	throwforce = 7
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 15
	atck_type = BLUNT
	max_integrity = 50
	resistance_flags = FIRE_PROOF
	melee_skill = /datum/skill/combat/spear
	melee_cd = 1 SECONDS
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/iron)
	var/charged
	var/cooldown = 1

/// STAFF OF LIGHTING STRIKES
/obj/item/magicstaff/lightingpower
	name = "Staff of The Mighty Weather"
	desc = "Enchanted staff with the power of The All Mighty Storms."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "king_scepter"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "king_scepter"
	force = 7
	throwforce = 10
	block_chance = 10
	color = "#D9BA55"
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/gold)

/obj/item/magicstaff/lightingpower/attack_self(mob/user, modifiers)
	. = ..()
	if(user.client)
		if(!charged)
			to_chat(user, "You begin to harvest [src] with the power of weather...")
			if(do_after(user, 5 SECONDS, user))
				charged = TRUE
		else
			to_chat(user, span_userdanger("[src] already charged!"))

/obj/item/magicstaff/lightingpower/attack(mob/living/M, mob/living/user, params)
	. = ..()
	if(.)
		return
	if(charged)
		charged = FALSE
		M.apply_damage(25, BURN, spread_damage = TRUE, attack_type = MAGIC)
		M.Paralyze(1.5 SECONDS)
		M.Knockdown(2 SECONDS)
		M.Jitter(5)
		to_chat(M, span_userdanger("A powerfull shock comes through your body!"))
		if(M.client)
			flash_color(M.client, "#bbb36d", 0.5 SECONDS)
		return TRUE

/obj/item/magicstaff/lightingpower/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	var/turf/T = get_turf(target)
	if(!charged)
		return ..()
	if(get_dist(T, user) <= 5)
		if(istype(T, /turf/open))
			charged = FALSE
			var/obj/effect/temp_visual/lighting_particles/M = new /obj/effect/temp_visual/lighting_particles(T)
			M.magical = TRUE
			return TRUE
		else
			return FALSE
	else
		charged = FALSE
		new /obj/effect/particle_effect/sparks(get_turf(src))
		to_chat(user, "You discharge [src], trying to exceed its power.")
		return FALSE

/// Lighting bolt effect
/obj/effect/temp_visual/lighting_particles
	icon = 'dwarfs/icons/effects/magiceffects.dmi'
	icon_state = "lighting_particles"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 0.5 SECONDS
	var/magical

/obj/effect/temp_visual/lighting_particles/Destroy()
	if(magical)
		new /obj/effect/temp_visual/lighting_bolt(loc)
	. = ..()

/obj/effect/temp_visual/lighting_bolt
	icon = 'dwarfs/icons/effects/magiceffects.dmi'
	icon_state = "lighting"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 0.25 SECONDS
	var/damage = 45

/obj/effect/temp_visual/lighting_bolt/Initialize()
	. = ..()
	playsound(src,'sound/magic/lightningbolt.ogg', 75, TRUE)
	new /obj/effect/particle_effect/sparks(get_turf(src))
	do_damage(get_turf(loc))

/obj/effect/temp_visual/lighting_bolt/proc/do_damage(turf/T)
	if(!damage)
		return
	for(var/mob/living/L in T.contents)
		if(L.client)
			flash_color(L.client, "#bbb36d", 1 SECONDS)
		to_chat(L, span_userdanger("You're struck by lighting bolt!"))
		L.apply_damage(damage, BURN, spread_damage = TRUE, attack_type = MAGIC)
		L.Jitter(1 SECONDS)

/// STAFF OF A NECROMANCER
/obj/item/magicstaff/necromant
	name = "Staff of a Rising Dead"
	desc = "Forbidden staff with the power to raise long-fallen to serve once more."
	icon = 'dwarfs/icons/items/weapons.dmi'
	icon_state = "king_scepter"
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	inhand_icon_state = "king_scepter"
	force = 3
	throwforce = 5
	block_chance = 20
	color = "#91315C"
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/gold)
	var/list/controlled = list()
	var/conjuring

/obj/item/magicstaff/necromant/attack_self(mob/user, modifiers)
	. = ..()
	if(conjuring)
		to_chat(user, span_revenminor("You're already trying to summon the dead!"))
		return FALSE
	else if(controlled.len > 0)
		to_chat(user, span_revenbignotice("This staff already maintains undead somewhere!"))
		destroy_controlled(user)
		return FALSE
	else if(cooldown < world.time && user.stat < SOFT_CRIT)
		risedead(user, get_turf(src))
		return TRUE
	else
		feed_action(user)
		return FALSE

/obj/item/magicstaff/pickup(mob/user)
	. = ..()
	user.faction += "necromancer"

/obj/item/magicstaff/dropped(mob/user, silent)
	. = ..()
	user.faction -= "necromancer"

/obj/item/magicstaff/necromant/proc/risedead(mob/user, atom/center)
	conjuring = TRUE
	to_chat(user, span_revennotice("You begin to call the dead to awaken upon your service."))
	var/list/turfs = RANGE_TURFS(2, center)
	turfs -= get_turf(center)
	for(var/turf/closed/Ci in turfs)
		turfs -= Ci
	for(var/turf/open/openspace/Cu in turfs)
		turfs -= Cu
	if(turfs)
		if(do_after(user, 10 SECONDS, user))
			for(var/c in 1 to 3)
				if(turfs)
					var/turf/picked = pick(turfs)
					turfs -= picked
					new /obj/effect/temp_visual/raise_dead(picked)
					new /obj/effect/temp_visual/raise_dead/behind(picked)
					var/mob/living/simple_animal/hostile/undead/undead = new /mob/living/simple_animal/hostile/undead(picked)
					controlled += undead
					undead.masterstaff = src
					undead.faction += "necromancer"
				else
					continue
				cooldown = world.time + 2 MINUTES
	else
		to_chat(user, span_revennotice("Not enough space for your servants to rise!"))
	conjuring = FALSE

/obj/item/magicstaff/necromant/proc/destroy_controlled(mob/living/user)
	to_chat(user, span_revenwarning("You begin to harvest bits of life essence of your undead!"))
	if(do_after(user, 7 SECONDS, user))
		for(var/mob/living/simple_animal/hostile/undead/undead in controlled)
			undead.death()
			user.apply_damage(-3, BRUTE, forced = TRUE, spread_damage = TRUE, attack_type = MAGIC)
			sleep(5)

/obj/item/magicstaff/necromant/proc/feed_action(mob/living/user)
	if(!user.stat <= SOFT_CRIT && user.health >= (user.maxHealth/2))
		if(do_after(user, 1 SECONDS, user))
			to_chat(user, span_revenboldnotice("You feed your life to the staff, decresing its cooldown."))
			user.apply_damage(6, BRUTE, forced = TRUE, spread_damage = TRUE, attack_type = MAGIC)
			cooldown -= 10 SECONDS
			if(cooldown > world.time && user.health >= (user.maxHealth/2))
				feed_action(user)
			return TRUE
	to_chat(user, span_revenwarning("Your life essence is too weak to feed the staff!"))

/// Raise effect
/obj/effect/temp_visual/raise_dead
	icon = 'dwarfs/icons/effects/magiceffects.dmi'
	icon_state = "necrotic_summon"
	layer = ABOVE_MOB_LAYER
	duration = 1.7 SECONDS

/obj/effect/temp_visual/raise_dead/behind
	icon_state = "necrotic_summon_b"
	layer = BELOW_MOB_LAYER
///
