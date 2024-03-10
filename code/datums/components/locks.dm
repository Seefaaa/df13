/*
This file contains key and lock datum.
If you want to implement a lock, you need a few things.

1. add COMSIG_KEY_USE signal send where you want locking and unlocking to happen
2. add COMSIG_TRY_LOCKED_ACTION in an if(SEND_SIGNAL) where you want to check if its locked

*/

/datum/component/lock
	var/datum/key/key
	var/locked = FALSE
	var/static/list/attachable_to = typecacheof(list(/obj/structure/mineral_door,/obj/structure/closet))


/datum/component/lock/Initialize(datum/key/locks_key)
	if(attachable_to && !(src.parent.type in attachable_to))
		return COMPONENT_INCOMPATIBLE
	key = locks_key
	RegisterSignal(parent, COMSIG_KEY_USE, PROC_REF(try_toggle_lock))
	RegisterSignal(parent, COMSIG_TRY_LOCKED_ACTION, PROC_REF(try_locked_action))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))


/datum/component/lock/proc/try_attach(obj/I)
	return

///Locking and unlocking action
/datum/component/lock/proc/try_toggle_lock(atom/source, datum/key/K, mob/user)
	SIGNAL_HANDLER
	if(K == key || !key)
		toggle_lock()
		user.visible_message(span_notice("<b>[user]</b> [locked ? "" : "un"]locks \the [parent].") , null, COMBAT_MESSAGE_RANGE)
		playsound(get_turf(source), 'sound/effects/stonelock.ogg', 65, vary = TRUE)
	else
		to_chat(user, span_warning("The key does not fit the lock!"))

/datum/component/lock/proc/toggle_lock()
	locked = !locked

/*
This is what will check if check if its locked and what will happen if it is locked,
returns TRUE if its locked(this is because if comp doesnt exist it will return false without being locked)
*/
/datum/component/lock/proc/try_locked_action(source, atom/user)
	SIGNAL_HANDLER
	if(locked)
		to_chat(user, span_warning("[parent] is locked!"))
		return TRUE
	return FALSE

/datum/component/lock/proc/on_examine(source, atom/user, list/examine_text)
	examine_text += "<br>It appears to be [locked ? span_warning("locked") : span_notice("unlocked")]"

/datum/key

/obj/item/lock
	name = "lock"
	desc = "a lock you can attach to a door"
	icon = 'dwarfs/icons/items/misc_items.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "lock"
	materials = /datum/material/iron
	var/datum/key/key_form = new()

/obj/item/lock/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/lock/attack_obj(obj/O, mob/living/user, params)
	. = ..()
	if(O._AddComponent(list(/datum/component/lock, key_form)))
		qdel(src)

/obj/item/key
	name = "key"
	desc = "a key to something"
	icon = 'dwarfs/icons/items/misc_items.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "key"
	worn_icon_state = "key"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	materials = /datum/material/iron
	var/prefix = ""
	var/datum/key/key_form

/obj/item/key/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/key/attack_obj(obj/O, mob/living/user, params)
	. = ..()
	SEND_SIGNAL(O, COMSIG_KEY_USE, key_form, user)

/obj/item/key/attackby(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/chisel))
		var/prefix = tgui_input_text(user,"What will be the tag of the key?", "Key tag", "", 30)
		name = prefix + " " + initial(name)
		update_name()
		return
	if(istype(I,/obj/item/smithing_hammer))
		if(istype(user.get_inactive_held_item(), /obj/item/key))
			var/obj/item/key/K = user.get_inactive_held_item()
			if(!key_form && K.key_form)
				switch(tgui_alert(user, "Do you want to copy the key from [K]?","Key prompt", list("Yes", "No")))
					if("Yes")
						src.key_form = K.key_form
						src.name = K.name
						update_name()
				return
	. = ..()

/obj/item/keyring
	name = "key ring"
	desc = "Holds multiple keys."
	icon = 'dwarfs/icons/items/misc_items.dmi'
	icon_state = "keyring"
	worn_icon_state = "keyring"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	materials = /datum/material/iron
	var/list/obj/item/key/keys = list()
	var/limit = 3

/obj/item/keyring/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/keyring/attack_obj(obj/O, mob/living/user, params)
	. = ..()
	for(var/obj/item/key/key in keys)
		SEND_SIGNAL(O, COMSIG_KEY_USE, key.key_form, user)

/obj/item/keyring/attackby(obj/item/attacking_item, mob/user, params)
	if(istype(attacking_item,/obj/item/key))
		add_key(attacking_item)
	. = ..()

/obj/item/keyring/proc/add_key(obj/item/key)
	if(LAZYLEN(keys) >= 4)
		to_chat(usr,span_warn("The key ring is full!"))
		return FALSE
	key.forceMove(src)
	keys += key
	update_icon()
	return TRUE

/obj/item/keyring/examine_more(mob/user)
	. = ..()
	if(!LAZYLEN(keys))
		. += "<hr>It contains no keys"
		return
	. += "<hr>It contains keys for "
	. += span_notice(jointext(keys, ","))

/obj/item/keyring/verb/remove_key()
	var/obj/item/key/chosen = tgui_input_list(usr, "Which key do you want to remove?", "Pick key", keys)
	if(chosen)
		chosen.forceMove(usr.loc)
		keys -= chosen
		update_icon()

/obj/item/keyring/update_overlays()
	. = ..()
	if(LAZYLEN(keys) >= 3)
		. += mutable_appearance(keys[3].build_material_icon(keys[3].icon,"keyring-3"))
	if(LAZYLEN(keys) >= 2)
		. += mutable_appearance(keys[2].build_material_icon(keys[2].icon,"keyring-2"))
	if(LAZYLEN(keys) >= 1)
		. += mutable_appearance(keys[1].build_material_icon(keys[1].icon,"keyring-1"))


/obj/effect/key_lock/Initialize()
	. = ..()
	var/obj/item/lock/L = new(loc)
	var/obj/item/key/K = new(loc)
	K.key_form = L.key_form
	qdel(src)
