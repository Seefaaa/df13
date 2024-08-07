/mob/living/carbon/human/getarmor(def_zone, type)
	//If you don't specify a bodypart, it selects a random bodypart
	if(!def_zone)
		def_zone = pick(bodyparts)

	if(isbodypart(def_zone))
		var/obj/item/bodypart/bp = def_zone
		if(bp)
			return checkarmor(def_zone, type)
	var/obj/item/bodypart/affecting = get_bodypart(check_zone(def_zone))
	if(affecting)
		return checkarmor(affecting, type)

/mob/living/carbon/human/proc/checkarmor(obj/item/bodypart/def_zone, d_type)
	if(!d_type)
		return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor.getRating(d_type)
	if(def_zone?.armor) //If mutant body has its own bodyparts with its armor values count them aswell
		protection += def_zone.armor.getRating(d_type)
	return protection

///Get all the clothing on a specific body part
/mob/living/carbon/human/proc/clothingonpart(obj/item/bodypart/def_zone)
	var/list/covering_part = list()
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, back, gloves, shoes, belt, s_store, glasses, ears, wear_neck) //Everything but pockets. Pockets are l_store and r_store. (if pockets were allowed, putting something armored, gloves or hats for example, would double up on the armor)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp , /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				covering_part += C
	return covering_part

/mob/living/carbon/human/on_hit(obj/projectile/P)
	if(dna?.species)
		dna.species.on_hit(P, src)


/mob/living/carbon/human/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	if(dna?.species)
		var/spec_return = dna.species.bullet_act(P, src)
		if(spec_return)
			return spec_return

	if(!(P.original == src && P.firer == src)) //can't block or reflect when shooting yourself
		if(P.reflectable & REFLECT_NORMAL)
			if(check_reflect(def_zone)) // Checks if you've passed a reflection% check
				visible_message(span_danger("[capitalize(src.name)] reflects [P.name]!") , \
								span_userdanger("[capitalize(src.name)] reflects [P.name]!"))
				// Find a turf near or on the original location to bounce to
				if(!isturf(loc)) //Open canopy mech (ripley) check. if we're inside something and still got hit
					P.force_hit = TRUE //The thing we're in passed the bullet to us. Pass it back, and tell it to take the damage.
					loc.bullet_act(P, def_zone, piercing_hit)
					return BULLET_ACT_HIT
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x
					var/new_angle_s = P.Angle + rand(120,240)
					while(new_angle_s > 180)	// Translate to regular projectile degrees
						new_angle_s -= 360
					P.set_angle(new_angle_s)

				return BULLET_ACT_FORCE_PIERCE // complete projectile permutation

		if(check_shields(null, P, "[P.name]", used_case=PARRY_CASE_PROJECTILE))
			P.on_hit(src, 100, def_zone, piercing_hit)
			return BULLET_ACT_BLOCK

	return ..()

///Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
/mob/living/carbon/human/proc/check_reflect(def_zone)
	if(wear_suit)
		if(wear_suit.IsReflect(def_zone))
			return TRUE
	if(head)
		if(head.IsReflect(def_zone))
			return TRUE
	for(var/obj/item/I in held_items)
		if(I.IsReflect(def_zone))
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/get_parry_cooldown()
	return dna.species ? dna.species.melee_parry_cooldown : 0.8 SECONDS

/mob/living/carbon/human/check_shields(mob/attacker, atom/AM, attack_text = null, chance_multiplier = 1, used_case = PARRY_CASE_WEAPON)
	if(world.time < src.next_parry)
		return FALSE
	if(src == attacker) // we don't parry ourselves
		return FALSE
	if(stat >= SOFT_CRIT)
		return FALSE
	var/obj/item/to_parry = get_active_held_item()
	var/obj/item/offhand = get_inactive_held_item()
	if(offhand && istype(offhand, /obj/item/shield))
		to_parry = offhand

	if(to_parry && !to_parry?.melee_skill) // we are blocking with something that isn't a weapon or a fist
		return FALSE

	var/datum/skill/combat/used_skill = to_parry ? to_parry.melee_skill : /datum/skill/combat/martial
	var/skill_level = get_skill_level(used_skill)
	var/parry_chance = get_skill_modifier(used_skill, SKILL_PARRY_MODIFIER) * chance_multiplier + (to_parry ? to_parry.block_chance : 0)
	var/parry_sound = to_parry ? to_parry.parrysound : 'sound/effects/hit_punch.ogg'
	var/parry_cooldown = to_parry ? to_parry.parry_cooldown : get_parry_cooldown() // parry_cooldown is grabbed from datum/species
	var/min_level

	if(isobj(AM) && used_case == PARRY_CASE_WEAPON)
		parry_chance *= initial(used_skill.weapon_parry_modifier)
		min_level = initial(used_skill.weapon_parry_level)
	else if(ismob(AM) && used_case == PARRY_CASE_HAND)
		parry_chance *= initial(used_skill.hand_parry_modifier)
		min_level = initial(used_skill.hand_parry_level)
	else if(isprojectile(AM) && used_case == PARRY_CASE_PROJECTILE)
		parry_chance *= initial(used_skill.projectile_parry_modifier)
		min_level = initial(used_skill.projectile_parry_level)

	// max out at 99% so we at least have a small chance at getting a hit in
	parry_chance = min(parry_chance, 99)

	if(skill_level >= min_level && prob(parry_chance))
		src.next_parry = world.time + parry_cooldown
		if(attack_text)
			visible_message(span_danger("<b>[src]</b> parries [attack_text]!"), span_danger("You parry [attack_text]!"), span_hear("You hear a swoosh!"), COMBAT_MESSAGE_RANGE, AM)
		if(parry_sound)
			playsound(src, parry_sound, 60, TRUE, -1)
		adjust_experience(used_skill, initial(used_skill.exp_per_parry))
		return TRUE
	return FALSE

/mob/living/carbon/human/hitby(atom/movable/AM, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	if(dna?.species)
		var/spec_return = dna.species.spec_hitby(AM, src)
		if(spec_return)
			return spec_return
	var/obj/item/I
	if(istype(AM, /obj/item))
		I = AM
		if(I.thrownby == WEAKREF(src)) //No throwing stuff at yourself to trigger hit reactions
			return ..()
	if(check_shields(null, AM, "[AM.name]"))
		hitpush = FALSE
		skipcatch = TRUE
		blocked = TRUE

	return ..()

/mob/living/carbon/human/grippedby(mob/living/user, instant = FALSE)
	if(w_uniform)
		w_uniform.add_fingerprint(user)
	..()

/mob/living/carbon/human/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(.)
		return
	return dna.species.spec_attackby(I, user, params, src)

/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user)
	if(!I || !user)
		return FALSE

	var/obj/item/bodypart/affecting
	if(user == src)
		affecting = get_bodypart(check_zone(user.zone_selected)) //stabbing yourself always hits the right target
	else
		var/zone_hit_chance = 80
		if(body_position == LYING_DOWN) // half as likely to hit a different zone if they're on the ground
			zone_hit_chance += 10
		affecting = get_bodypart(ran_zone(user.zone_selected, zone_hit_chance))
	var/target_area = parse_zone(check_zone(user.zone_selected)) //our intended target

	SEND_SIGNAL(I, COMSIG_ITEM_ATTACK_ZONE, src, user, affecting)

	SSblackbox.record_feedback("nested tally", "item_used_for_combat", 1, list("[I.force]", "[I.type]"))
	SSblackbox.record_feedback("tally", "zone_targeted", 1, target_area)

	// the attacked_by code varies among species
	return dna.species.spec_attacked_by(I, user, affecting, a_intent, src)

/mob/living/carbon/human/attack_hand(mob/user, list/modifiers)
	if(..()) //to allow surgery to return properly.
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		dna.species.spec_attack_hand(H, src, null, modifiers)

/mob/living/carbon/human/attack_paw(mob/living/carbon/human/M)
	var/dam_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	if(M.a_intent == INTENT_HELP)
		..() //shaking
		return FALSE

	if(M.a_intent == INTENT_DISARM) //Always drop item in hand, if no item, get stunned instead.
		var/obj/item/I = get_active_held_item()
		if(I && !(I.item_flags & ABSTRACT) && dropItemToGround(I))
			playsound(loc, 'sound/weapons/slash.ogg', 25, TRUE, -1)
			visible_message(span_danger("[M] disarmed [src]!") , \
							span_userdanger("[M] disarmed you!") , span_hear("You hear aggressive shuffling!") , null, M)
			to_chat(M, span_danger("You disarm [src]!"))
		else if(!M.client || prob(5)) // only natural monkeys get to stun reliably, (they only do it occasionaly)
			playsound(loc, 'sound/weapons/pierce.ogg', 25, TRUE, -1)
			if (src.IsKnockdown() && !src.IsParalyzed())
				Paralyze(40)
				log_combat(M, src, "pinned")
				visible_message(span_danger("[M] pins [src] down!") , \
								span_userdanger("[M] pins you down!") , span_hear("You hear shuffling and a muffled groan!") , null, M)
				to_chat(M, span_danger("You pin [src] down!"))
			else
				Knockdown(30)
				log_combat(M, src, "tackled")
				visible_message(span_danger("[M] tackles [src] down!") , \
								span_userdanger("[M] tackles you down!") , span_hear("You hear aggressive shuffling followed by a loud thud!") , null, M)
				to_chat(M, span_danger("You tackle [src] down!"))

	if(M.limb_destroyer)
		dismembering_strike(M, affecting.body_zone)

	if(try_inject(M, affecting, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))//Thick suits can stop monkey bites.
		if(..()) //successful monkey bite
			var/damage = rand(M.dna.species.punchdamagelow, M.dna.species.punchdamagehigh)
			if(!damage)
				return
			if(check_shields(M, M, "[M.name]"))
				return FALSE
			if(stat != DEAD)
				apply_damage(damage, BRUTE, affecting, run_armor_check(affecting, PIERCE))
		return TRUE

/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!.)
		return
	var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
	if(check_shields(M, M, "[M.name]"))
		return FALSE
	var/dam_zone = dismembering_strike(M, pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
	if(!dam_zone) //Dismemberment successful
		return TRUE
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(dam_zone))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	var/armor = run_armor_check(affecting, M.atck_type, armour_penetration = M.armour_penetration)
	var/attack_direction = get_dir(M, src)
	apply_damage(damage, M.melee_damage_type, affecting, armor, wound_bonus = M.wound_bonus, bare_wound_bonus = M.bare_wound_bonus, attack_type = M.atck_type, attack_direction = attack_direction)

/mob/living/carbon/human/ex_act(severity, target, origin)
	if(TRAIT_BOMBIMMUNE in dna.species.species_traits)
		return
	..()
	if (!severity || QDELETED(src))
		return
	var/brute_loss = 0
	var/burn_loss = 0
	var/bomb_armor = getarmor(null, BLUNT)

//200 max knockdown for EXPLODE_HEAVY
//160 max knockdown for EXPLODE_LIGHT

	var/obj/item/organ/ears/ears = getorganslot(ORGAN_SLOT_EARS)
	switch (severity)
		if (EXPLODE_DEVASTATE)
			if(bomb_armor < EXPLODE_GIB_THRESHOLD) //gibs the mob if their bomb armor is lower than EXPLODE_GIB_THRESHOLD
				for(var/thing in contents)
					switch(severity)
						if(EXPLODE_DEVASTATE)
							SSexplosions.high_mov_atom += thing
						if(EXPLODE_HEAVY)
							SSexplosions.med_mov_atom += thing
						if(EXPLODE_LIGHT)
							SSexplosions.low_mov_atom += thing
				gib()
				return
			else
				brute_loss = 500
				var/atom/throw_target = get_edge_target_turf(src, get_dir(src, get_step_away(src, src)))
				throw_at(throw_target, 200, 4)
				damage_clothes(400 - bomb_armor, BRUTE, BLUNT)

		if (EXPLODE_HEAVY)
			brute_loss = 60
			burn_loss = 60
			if(bomb_armor)
				brute_loss = 30*(2 - round(bomb_armor*0.01, 0.05))
				burn_loss = brute_loss				//damage gets reduced from 120 to up to 60 combined brute+burn
			damage_clothes(200 - bomb_armor, BRUTE, BLUNT)
			if (ears && !HAS_TRAIT_FROM(src, TRAIT_DEAF, CLOTHING_TRAIT))
				ears.adjustEarDamage(30, 120)
			Unconscious(20)							//short amount of time for follow up attacks against elusive enemies like wizards
			playsound_local(get_turf(src), 'sound/weapons/flashbang.ogg', 100, TRUE, 8)
			flash_act(1, TRUE, TRUE, length = 2.5)
			Knockdown(200 - (bomb_armor * 1.6)) 	//between ~4 and ~20 seconds of knockdown depending on bomb armor

		if(EXPLODE_LIGHT)
			brute_loss = 30
			if(bomb_armor)
				brute_loss = 15*(2 - round(bomb_armor*0.01, 0.05))
			damage_clothes(max(50 - bomb_armor, 0), BRUTE, BLUNT)
			if (ears && !HAS_TRAIT_FROM(src, TRAIT_DEAF, CLOTHING_TRAIT))
				ears.adjustEarDamage(15,60)
			Knockdown(160 - (bomb_armor * 1.6))		//100 bomb armor will prevent knockdown altogether

	take_overall_damage(brute_loss,burn_loss)

	//attempt to dismember bodyparts
	if(severity <= 2 || !bomb_armor)
		var/max_limb_loss = round(4/severity) //so you don't lose four limbs at severity 3.
		for(var/X in bodyparts)
			var/obj/item/bodypart/BP = X
			if(prob(50/severity) && !prob(getarmor(BP, BLUNT)) && BP.body_zone != BODY_ZONE_HEAD && BP.body_zone != BODY_ZONE_CHEST)
				BP.brute_dam = BP.max_damage
				BP.dismember(BRUTE, TRUE, FALSE)
				max_limb_loss--
				if(!max_limb_loss)
					break

///Calculates the siemens coeff based on clothing and species, can also restart hearts.
/mob/living/carbon/human/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	//Calculates the siemens coeff based on clothing. Completely ignores the arguments
	if(flags & SHOCK_TESLA) //I hate this entire block. This gets the siemens_coeff for tesla shocks
		if(gloves && gloves.siemens_coefficient <= 0)
			siemens_coeff -= 0.5
		if(wear_suit)
			if(wear_suit.siemens_coefficient == -1)
				siemens_coeff -= 1
			else if(wear_suit.siemens_coefficient <= 0)
				siemens_coeff -= 0.95
		siemens_coeff = max(siemens_coeff, 0)
	else if(!(flags & SHOCK_NOGLOVES)) //This gets the siemens_coeff for all non tesla shocks
		if(gloves)
			siemens_coeff *= gloves.siemens_coefficient
	siemens_coeff *= dna.species.siemens_coeff
	. = ..()
	//Don't go further if the shock was blocked/too weak.
	if(!.)
		return
	//Note we both check that the user is in cardiac arrest and can actually heartattack
	//If they can't, they're missing their heart and this would runtime
	if(undergoing_cardiac_arrest() && can_heartattack() && !(flags & SHOCK_ILLUSION))
		if(shock_damage * siemens_coeff >= 1 && prob(25))
			var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
			if(heart.Restart() && stat == CONSCIOUS)
				to_chat(src, span_notice("You feel your heart beating again!"))
	electrocution_animation(40)

/mob/living/carbon/human/acid_act(acidpwr, acid_volume, bodyzone_hit) //todo: update this to utilize check_obscured_slots() //and make sure it's check_obscured_slots(TRUE) to stop aciding through visors etc
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = acidpwr * min(acid_volume*0.005, 0.1)
	//HEAD//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_HEAD) //only if we didn't specify a zone or if that zone is the head.
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			if(!(head_clothes.resistance_flags & UNACIDABLE))
				head_clothes.acid_act(acidpwr, acid_volume)
				update_inv_glasses()
				update_inv_wear_mask()
				update_inv_neck()
				update_inv_head()
			else
				to_chat(src, span_notice("Your [head_clothes.name] protects your head and face from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_HEAD)
			if(.)
				damaged += .
			if(ears)
				inventory_items_to_kill += ears

	//CHEST//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			if(!(chest_clothes.resistance_flags & UNACIDABLE))
				chest_clothes.acid_act(acidpwr, acid_volume)
				update_inv_w_uniform()
				update_inv_wear_suit()
			else
				to_chat(src, span_notice("Your [chest_clothes.name] protects your body from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_CHEST)
			if(.)
				damaged += .
			if(r_store)
				inventory_items_to_kill += r_store
			if(l_store)
				inventory_items_to_kill += l_store
			if(s_store)
				inventory_items_to_kill += s_store


	//ARMS & HANDS//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_ARM || bodyzone_hit == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit

		if(arm_clothes)
			if(!(arm_clothes.resistance_flags & UNACIDABLE))
				arm_clothes.acid_act(acidpwr, acid_volume)
				update_inv_gloves()
				update_inv_w_uniform()
				update_inv_wear_suit()
			else
				to_chat(src, span_notice("Your [arm_clothes.name] protects your arms and hands from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_R_ARM)
			if(.)
				damaged += .
			. = get_bodypart(BODY_ZONE_L_ARM)
			if(.)
				damaged += .


	//LEGS & FEET//
	if(!bodyzone_hit || bodyzone_hit == BODY_ZONE_L_LEG || bodyzone_hit == BODY_ZONE_R_LEG || bodyzone_hit == "feet")
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (w_uniform.body_parts_covered & LEGS))))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (bodyzone_hit != "feet" && (wear_suit.body_parts_covered & LEGS))))
			leg_clothes = wear_suit
		if(leg_clothes)
			if(!(leg_clothes.resistance_flags & UNACIDABLE))
				leg_clothes.acid_act(acidpwr, acid_volume)
				update_inv_shoes()
				update_inv_w_uniform()
				update_inv_wear_suit()
			else
				to_chat(src, span_notice("Your [leg_clothes.name] protects your legs and feet from the acid!"))
		else
			. = get_bodypart(BODY_ZONE_R_LEG)
			if(.)
				damaged += .
			. = get_bodypart(BODY_ZONE_L_LEG)
			if(.)
				damaged += .


	//DAMAGE//
	for(var/obj/item/bodypart/affecting in damaged)
		affecting.receive_damage(acidity, 2*acidity)

		if(affecting.name == BODY_ZONE_HEAD)
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.receive_damage(acidity, 2*acidity)
				emote("agony")
				facial_hairstyle = "Shaved"
				hairstyle = "Bald"
				update_hair()
				ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)

		update_damage_overlays()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(!bodyzone_hit)
		if(back)
			inventory_items_to_kill += back
		if(belt)
			inventory_items_to_kill += belt

		inventory_items_to_kill += held_items

	for(var/obj/item/inventory_item in inventory_items_to_kill)
		inventory_item.acid_act(acidpwr, acid_volume)
	return TRUE

/mob/living/carbon/human/help_shake_act(mob/living/carbon/M)
	if(!istype(M))
		return

	if(src == M)
		if(has_status_effect(STATUS_EFFECT_CHOKINGSTRAND))
			to_chat(src, span_notice("You attempt to remove the durathread strand from around your neck."))
			if(do_after(src, 3.5 SECONDS, src))
				to_chat(src, span_notice("You succesfuly remove the durathread strand."))
				remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)
			return
		check_self_for_injuries()


	else
		if(wear_suit)
			wear_suit.add_fingerprint(M)
		else if(w_uniform)
			w_uniform.add_fingerprint(M)

		..()


/mob/living/carbon/human/check_self_for_injuries()
	if(stat >= UNCONSCIOUS)
		return
	var/list/combined_msg = list()

	visible_message(span_notice("[src] examines [p_them()]self."), \
		span_notice("You check yourself for injuries."))

	var/list/missing = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)

	combined_msg += "<div class='examine_block'><span class='info'>My current condition:</span><hr><table>"

	for(var/obj/item/bodypart/body_part as anything in bodyparts)
		missing -= body_part.body_zone
		if(body_part.is_pseudopart) //don't show injury text for fake bodyparts; ie chainsaw arms or synthetic armblades
			continue
		var/limb_max_damage = body_part.max_damage
		var/status = ""
		var/brutedamage = body_part.brute_dam
		var/burndamage = body_part.burn_dam
		if(hallucination)
			if(prob(30))
				brutedamage += rand(30,40)
			if(prob(30))
				burndamage += rand(30,40)

		if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
			status = "BRUTE: [brutedamage]</span>\] And \[<span class='warning'>BURN: [burndamage]"
			if(!brutedamage && !burndamage)
				status = "OK"

		else
			if(body_part.type in hal_screwydoll)//Are we halucinating?
				brutedamage = (hal_screwydoll[body_part.type] * 0.2)*limb_max_damage

			if(brutedamage > 0)
				status = body_part.light_brute_msg
			if(brutedamage > (limb_max_damage*0.4))
				status = body_part.medium_brute_msg
			if(brutedamage > (limb_max_damage*0.8))
				status = body_part.heavy_brute_msg
			if(brutedamage > 0 && burndamage > 0)
				status += "</span>\] \[<span class='warning'>"

			if(burndamage > (limb_max_damage*0.8))
				status += body_part.heavy_burn_msg
			else if(burndamage > (limb_max_damage*0.2))
				status += body_part.medium_burn_msg
			else if(burndamage > 0)
				status += body_part.light_burn_msg

			if(status == "")
				status = "OK"
		var/no_damage
		if(status == "OK")
			no_damage = TRUE
		var/isdisabled = ""
		if(body_part.bodypart_disabled)
			isdisabled = "\[PARALYZED\]"
			if(no_damage)
				isdisabled += " but otherwise"
			else
				isdisabled += " and"
		var/partmsg = "<tr><td><b>[uppertext(body_part.name)]:</b></td><td>[isdisabled] \[<span class='[no_damage ? "info" : "red"]'>[uppertext(status)]</span>\] "

		if(body_part.get_bleed_rate())
			partmsg += "\[<span class='red'>BLEEDING</span>\] "

		for(var/obj/item/I in body_part.embedded_objects)
			if(I.isEmbedHarmless())
				partmsg += "\[<a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(body_part)]' class='info'>[uppertext(I.name)]</a>\]"
			else
				partmsg += "\[<a href='?src=[REF(src)];embedded_object=[REF(I)];embedded_limb=[REF(body_part)]' class='red'>[uppertext(I.name)]</a>\]"

		combined_msg += "[partmsg]</td></tr>"

	for(var/t in missing)
		combined_msg += "<tr><td><b>[uppertext(parse_zone(t))]:</b></td><td>\[<span class='boldannounce'>IS MISSING</span>\]</td></tr>"

	combined_msg += "</table>"

	if(getStaminaLoss())
		if(getStaminaLoss() > 30)
			combined_msg += span_info("You're completely exhausted.")
		else
			combined_msg += span_info("You feel fatigued.")
	if(HAS_TRAIT(src, TRAIT_SELF_AWARE))
		if(toxloss)
			if(toxloss > 10)
				combined_msg += span_danger("You feel sick.")
			else if(toxloss > 20)
				combined_msg += span_danger("You feel nauseated.")
			else if(toxloss > 40)
				combined_msg += span_danger("You feel very unwell!")
		if(oxyloss)
			if(oxyloss > 10)
				combined_msg += span_danger("You feel lightheaded.")
			else if(oxyloss > 20)
				combined_msg += span_danger("Your thinking is clouded and distant.")
			else if(oxyloss > 30)
				combined_msg += span_danger("You're choking!")

	if(!HAS_TRAIT(src, TRAIT_NOHUNGER))
		switch(nutrition)
			if(NUTRITION_LEVEL_FULL to INFINITY)
				combined_msg += "<span class='info'>You're completely stuffed!</span>"
			if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
				combined_msg += "<span class='info'>You're well fed!</span>"
			if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
				combined_msg += "<span class='info'>You're not hungry.</span>"
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				combined_msg += "<span class='info'>You could use a bite to eat.</span>"
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				combined_msg += "<span class='info'>You feel quite hungry.</span>"
			if(0 to NUTRITION_LEVEL_STARVING)
				combined_msg += "<span class='danger'>You're starving!</span>"

	//Compiles then shows the list of damaged organs and broken organs
	var/list/broken = list()
	var/list/damaged = list()
	var/broken_message
	var/damaged_message
	var/broken_plural
	var/damaged_plural
	//Sets organs into their proper list
	for(var/O in internal_organs)
		var/obj/item/organ/organ = O
		if(organ.organ_flags & ORGAN_FAILING)
			if(broken.len)
				broken += ", "
			broken += organ.name
		else if(organ.damage > organ.low_threshold)
			if(damaged.len)
				damaged += ", "
			damaged += organ.name
	//Checks to enforce proper grammar, inserts words as necessary into the list
	if(broken.len)
		if(broken.len > 1)
			broken.Insert(broken.len, "and ")
			broken_plural = TRUE
		else
			var/holder = broken[1]	//our one and only element
			if(holder[length(holder)] == "s")
				broken_plural = TRUE
		//Put the items in that list into a string of text
		for(var/B in broken)
			broken_message += B
		combined_msg += span_warning("<hr>Your [broken_message] [broken_plural ? "are" : "is"] non-functional!")
	if(damaged.len)
		if(damaged.len > 1)
			damaged.Insert(damaged.len, "and ")
			damaged_plural = TRUE
		else
			var/holder = damaged[1]
			if(holder[length(holder)] == "s")
				damaged_plural = TRUE
		for(var/D in damaged)
			damaged_message += D
		combined_msg += span_info("Your [damaged_message] [damaged_plural ? "are" : "is"] hurt.")

	to_chat(src, combined_msg.Join("\n"))

/mob/living/carbon/human/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	if(damage_type != BRUTE && damage_type != BURN)
		return
	damage_amount *= 0.5 //0.5 multiplier for balance reason, we don't want clothes to be too easily destroyed
	var/list/torn_items = list()

	//HEAD//
	if(!def_zone || def_zone == BODY_ZONE_HEAD)
		var/obj/item/clothing/head_clothes = null
		if(glasses)
			head_clothes = glasses
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			torn_items += head_clothes
		else if(ears)
			torn_items += ears

	//CHEST//
	if(!def_zone || def_zone == BODY_ZONE_CHEST)
		var/obj/item/clothing/chest_clothes = null
		if(w_uniform)
			chest_clothes = w_uniform
		if(wear_suit)
			chest_clothes = wear_suit
		if(chest_clothes)
			torn_items += chest_clothes

	//ARMS & HANDS//
	if(!def_zone || def_zone == BODY_ZONE_L_ARM || def_zone == BODY_ZONE_R_ARM)
		var/obj/item/clothing/arm_clothes = null
		if(gloves)
			arm_clothes = gloves
		if(w_uniform && ((w_uniform.body_parts_covered & HANDS) || (w_uniform.body_parts_covered & ARMS)))
			arm_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & HANDS) || (wear_suit.body_parts_covered & ARMS)))
			arm_clothes = wear_suit
		if(arm_clothes)
			torn_items |= arm_clothes

	//LEGS & FEET//
	if(!def_zone || def_zone == BODY_ZONE_L_LEG || def_zone == BODY_ZONE_R_LEG)
		var/obj/item/clothing/leg_clothes = null
		if(shoes)
			leg_clothes = shoes
		if(w_uniform && ((w_uniform.body_parts_covered & FEET) || (w_uniform.body_parts_covered & LEGS)))
			leg_clothes = w_uniform
		if(wear_suit && ((wear_suit.body_parts_covered & FEET) || (wear_suit.body_parts_covered & LEGS)))
			leg_clothes = wear_suit
		if(leg_clothes)
			torn_items |= leg_clothes

	for(var/obj/item/I in torn_items)
		I.take_damage(damage_amount, damage_type, damage_flag, 0)
