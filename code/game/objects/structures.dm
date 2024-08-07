/// Inert structures, such as girders, machine frames, and crates/lockers.
/obj/structure
	icon = 'icons/obj/structures.dmi'
	max_integrity = 150
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT
	obj_flags = parent_type::obj_flags | IGNORES_GRADES
	layer = BELOW_OBJ_LAYER
	flags_ricochet = RICOCHET_HARD
	receive_ricochet_chance_mod = 0.6
	pass_flags_self = PASSSTRUCTURE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	impact_damage = 30
	var/broken = 0 //similar to machinery's stat BROKEN
	var/del_on_zimpact = TRUE
	hit_sound = 'dwarfs/sounds/structures/generic_hit.ogg'

/obj/structure/Initialize()
	if (!armor)
		armor = list(SHARP = 0, PIERCE = 0, BLUNT = 0, FIRE = 50, ACID = 50)
	. = ..()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)
		if(smoothing_flags & SMOOTH_CORNERS)
			icon_state = ""

/obj/structure/Destroy()
	if(smoothing_flags & (SMOOTH_CORNERS|SMOOTH_BITMASK))
		QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/structure/attack_hand(mob/user)
	. = ..()
	if(.)
		return

/obj/structure/ui_act(action, params)
	add_fingerprint(usr)
	return ..()

/obj/structure/examine(mob/user)
	. = ..()
	if(!(resistance_flags & INDESTRUCTIBLE))
		if(resistance_flags & ON_FIRE)
			. += "<hr><span class='warning'>It's on fire!</span>"
		if(broken)
			. += "<hr><span class='notice'>It's broken.</span>"
		var/examine_status = examine_status(user)
		if(examine_status)
			. += "<hr>"
			. += examine_status

/obj/structure/proc/examine_status(mob/user) //An overridable proc, mostly for falsewalls.
	var/healthpercent = (obj_integrity/max_integrity) * 100
	switch(healthpercent)
		if(50 to 99)
			return  "There are scratches visible on it."
		if(25 to 50)
			return  "There are dents visible on it."
		if(0 to 25)
			if(!broken)
				return span_warning("It looks like it's about to break!")

/obj/structure/zap_act(power, zap_flags)
	if(zap_flags & ZAP_OBJ_DAMAGE)
		take_damage(power/8000, BURN, "energy")
	power -= power/2000 //walls take a lot out of ya
	. = ..()

/obj/structure/onZImpact(turf/impacted_turf, levels, message)
	. = ..()
	if(QDELETED(src))
		return
	if(del_on_zimpact)
		addtimer(CALLBACK(src, PROC_REF(obj_destruction)), 0.5 SECONDS)

/obj/structure/proc/spawn_debris()
	var/obj/structure/debris/structure/debris = new(get_turf(src))
	var/list/mats = materials2mats(materials)
	var/image/debris_icon = mats2debris(mats)
	debris.add_overlay(debris_icon)
	debris.materials = materials

/obj/structure/obj_destruction(damage_flag)
	if(QDELETED(src))
		return
	spawn_debris()
	qdel(src)
