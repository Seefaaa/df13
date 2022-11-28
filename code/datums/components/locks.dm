/*
This file contains key and lock datum.
If you want to implement a lock, you need a few things.

1. add COMSIG_KEY_USE signal send where you want locking and unlocking to happen
2. add COMSIG_TRY_LOCKED_ACTION in an if(SEND_SIGNAL) where you want to check if its locked

*/

/datum/component/lock
	var/datum/key/key
	var/locked = FALSE
	var/static/list/attachable_to = typecacheof(list(/obj/structure/mineral_door, /obj/item/key))

/datum/component/lock/Initialize(datum/key/locks_key)
	//(_owner, _key = null, /datum/callback/_lock_callback)
	// if(attachable_to && !(src.parent in attachable_to))
	// 	return COMPONENT_INCOMPATIBLE
	key = locks_key
	RegisterSignal(parent, COMSIG_KEY_USE, .proc/try_toggle_lock)
	RegisterSignal(parent, COMSIG_TRY_LOCKED_ACTION, .proc/try_locked_action)


/datum/component/lock/proc/try_attach(obj/I)

///Locking and unlocking action
/datum/component/lock/proc/try_toggle_lock(atom/source, datum/key/K, mob/user)
	SIGNAL_HANDLER
	if(K == key || !key)
		toggle_lock()
		user.visible_message(span_notice("<b>[user]</b> [locked ? "" : "un"]locks \the [parent].") , null, COMBAT_MESSAGE_RANGE)
		playsound(get_turf(source), 'sound/effects/stonelock.ogg', 65, vary = TRUE)
	else
		to_chat(user, span_warn("The key does not fit the lock!"))

/datum/component/lock/proc/toggle_lock()
	locked = !locked

/*
This is what will check if check if its locked and what will happen if it is locked,
returns TRUE if its locked(this is because if comp doesnt exist it will return false without being locked)
*/
/datum/component/lock/proc/try_locked_action(source, atom/user)
	SIGNAL_HANDLER
	if(locked)
		to_chat(user, span_warn("[parent] is locked!"))
		return TRUE
	return FALSE


/datum/key

/obj/item/lock
	name = "lock"
	desc = "a lock you can attach to a door"
	icon = 'dwarfs/icons/items/misc_items.dmi'
	icon_state = "lock"
	var/datum/key/key_form = new()


/obj/item/lock/Initialize()
	. = ..()
	AddComponent(/datum/component/lock, key_form)

/obj/item/lock/attack_obj(obj/O, mob/living/user, params)
	. = ..()
	O._AddComponent(list(/datum/component/lock, key_form))
	qdel(src)

/obj/item/key
	name = "key"
	desc = "a key to something"
	icon = 'dwarfs/icons/items/misc_items.dmi'
	icon_state = "key"
	var/prefix = ""
	var/datum/key/key_form

/obj/item/key/attack_obj(obj/O, mob/living/user, params)
	. = ..()
	SEND_SIGNAL(O, COMSIG_KEY_USE, key_form, user)

/obj/item/key/attackby(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/chisel))
		var/prefix = tgui_input_text(user,"What will be the tag of the key?", "Key tag", "", 30)
w		name = prefix + " " + initial(name)
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


/obj/effect/key_lock/Initialize()
	. = ..()
	var/obj/item/lock/L = new(loc)
	var/obj/item/key/K = new(loc)
	K.key_form = L.key_form
	qdel(src)
