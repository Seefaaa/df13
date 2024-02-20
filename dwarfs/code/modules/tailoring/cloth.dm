/obj/item/stack/sheet/cloth
	name = "cloth"
	desc = "A piece of fabric. Can be made into clothing."
	singular_name = "piece of fabric"
	icon = 'dwarfs/icons/items/components.dmi'
	icon_state = "cloth"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/stack/sheet/cloth/get_fuel()
	return amount*2

/obj/item/stack/sheet/string
	name = "string ball"
	desc = "Long strings of fibers rolled into a ball. Processed in loom into fabric."
	singular_name = "string"
	icon = 'dwarfs/icons/items/components.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "string"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/stack/sheet/string/get_fuel()
	return amount
