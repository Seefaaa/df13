/obj/item/storage/goat
	name = "goat_bag"
	desc = "Mounted on goats for convenient transportation."
	icon = 'dwarfs/icons/items/storage.dmi'
	icon_state = "satchel"

/obj/item/storage/goat/PopulateContents()
	var/datum/component/storage/S = GetComponent(/datum/component/storage/concrete)
	S.max_items = 20
	S.max_combined_w_class = 80
	S.max_w_class = 3

/obj/item/storage/seed_bag
	name = "seed bag"
	desc = "Handy for keeping all of you seeds safe."
	icon = 'dwarfs/icons/items/storage.dmi'
	icon_state = "seed_bag"
	inhand_icon_state = "seed_bag"

/obj/item/storage/seed_bag/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(contents.len)
		icon_state = "seed_bag_full"

/obj/item/storage/seed_bag/Exited(atom/movable/gone, direction)
	. = ..()
	if(!contents.len)
		icon_state = "seed_bag"

/obj/item/storage/seed_bag/PopulateContents()
	var/datum/component/storage/S = GetComponent(/datum/component/storage/concrete)
	S.display_numerical_stacking = TRUE
	S.max_combined_w_class = 100
	S.max_items = 100
	S.set_holdable(list(
		/obj/item/growable/seeds
	))

