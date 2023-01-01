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
