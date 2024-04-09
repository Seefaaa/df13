/obj/item/storage/soil
	name = "soil bag"
	desc = "How does it work?"
	icon = 'dwarfs/icons/items/storage.dmi'
	icon_state = "soil_bag"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	component_type = /datum/component/storage/concrete/stack

/obj/item/storage/soil/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/stack/STR = GetComponent(/datum/component/storage/concrete/stack)
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_combined_stack_amount = 50
	STR.set_holdable(list(
		/obj/item/stack/dirt,
		/obj/item/stack/ore/smeltable/sand
	))

/obj/item/storage/quiver
	name = "quiver"
	icon = 'dwarfs/icons/items/storage.dmi'
	icon_state = "satchel"
	worn_icon_state = "quiver"
	inhand_icon_state = "quiver"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	component_type = /datum/component/storage/concrete
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT

/obj/item/storage/quiver/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/STR = GetComponent(/datum/component/storage/concrete)
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 200
	STR.max_items = 15
	STR.display_numerical_stacking = TRUE

/obj/item/storage/quiver/update_icon_state()
	. = ..()
	icon_state = initial(icon_state) + (contents.len ? "_full" : "")

/obj/item/storage/quiver/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/item/storage/quiver/Exited(atom/movable/gone, direction)
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/item/storage/quiver/arrows
	name = "arrow quiver"
	desc = "A place to store all your arrows."
	icon_state = "quiver_arrows"

/obj/item/storage/quiver/arrows/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/STR = GetComponent(/datum/component/storage/concrete)
	STR.set_holdable(list(/obj/item/ammo_casing/caseless/bow_arrow))

/obj/item/storage/quiver/bolts
	name = "bolt quiver"
	desc = "A place to store all your bolts."
	icon_state = "quiver_bolts"

/obj/item/storage/quiver/bolts/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/STR = GetComponent(/datum/component/storage/concrete)
	STR.set_holdable(list(/obj/item/ammo_casing/caseless/crossbow_arrow))
