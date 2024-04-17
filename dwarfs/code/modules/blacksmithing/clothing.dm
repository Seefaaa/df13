/obj/item/clothing/suit/light_plate
	name = "chest plate"
	desc = "Covers only chest area."
	worn_icon = 'dwarfs/icons/mob/clothing/suit.dmi'
	worn_icon_state = "chestplate_light"
	body_parts_covered = CHEST|GROIN
	icon = 'dwarfs/icons/items/clothing/suit.dmi'
	icon_state = "light_plate"
	inhand_icon_state = "light_plate"
	allowed = TRUE
	materials = /datum/material/iron

/obj/item/clothing/suit/light_plate/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/suit/heavy_plate
	name = "plate armor"
	desc = "Sturdy but heavy."
	worn_icon = 'dwarfs/icons/mob/clothing/suit.dmi'
	worn_icon_state = "chestplate_heavy"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	w_class = WEIGHT_CLASS_GIGANTIC
	slowdown = 1
	allowed = TRUE
	icon = 'dwarfs/icons/items/clothing/suit.dmi'
	icon_state = "heavy_plate"
	inhand_icon_state = "heavy_plate"
	materials = /datum/material/iron
	var/footstep = 1
	var/mob/listeningTo
	var/list/random_step_sound = list('sound/effects/heavystep1.ogg'=1,\
									  'sound/effects/heavystep2.ogg'=1,\
									  'sound/effects/heavystep3.ogg'=1,\
									  'sound/effects/heavystep4.ogg'=1,\
									  'sound/effects/heavystep5.ogg'=1,\
									  'sound/effects/heavystep6.ogg'=1,\
									  'sound/effects/heavystep7.ogg'=1)

/obj/item/clothing/suit/heavy_plate/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/suit/heavy_plate/proc/on_mob_move()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/H = loc
	if(!istype(H) || H.wear_suit != src)
		return
	if(footstep > 2)
		playsound(src, pick(random_step_sound), 100, TRUE)
		footstep = 0
	else
		footstep++

/obj/item/clothing/suit/heavy_plate/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_OCLOTHING)
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		return
	if(listeningTo == user)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_mob_move))
	listeningTo = user

/obj/item/clothing/suit/heavy_plate/dropped()
	. = ..()
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/suit/heavy_plate/Destroy()
	listeningTo = null
	return ..()

/obj/item/clothing/under/chainmail
	name = "chainmail"
	desc = "Great protection from stabs and slashes for its weight."
	worn_icon = 'dwarfs/icons/mob/clothing/under.dmi'
	worn_icon_state = "chainmail"
	icon = 'dwarfs/icons/items/clothing/under.dmi'
	icon_state = "chainmail"
	inhand_icon_state = "chainmail"
	materials = /datum/material/iron

/obj/item/clothing/under/chainmail/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/head/heavy_plate
	name = "heavy plate helmet"
	desc = "Protects your head from all unexpected and expected attacks."
	worn_icon_state = "helmet_heavy"
	icon = 'dwarfs/icons/items/clothing/head.dmi'
	icon_state = "helmet_heavy"
	dynamic_hair_suffix = ""
	flags_inv = HIDEMASK|HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	materials = /datum/material/iron

/obj/item/clothing/head/heavy_plate/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/head/light_plate
	name = "light plate helmet"
	desc = "Protects your head from dangers. A good compromise between protection and usability."
	icon = 'dwarfs/icons/items/clothing/head.dmi'
	icon_state = "helmet_light"
	dynamic_hair_suffix = ""
	flags_inv = HIDEHAIR
	materials = /datum/material/iron

/obj/item/clothing/head/light_plate/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/gloves/plate_gloves
	name = "plate gloves"
	desc = "Will save your hands from unexpected losses."
	worn_icon = 'dwarfs/icons/mob/clothing/hands.dmi'
	worn_icon_state = "plate_gloves"
	icon = 'dwarfs/icons/items/clothing/gloves.dmi'
	icon_state = "plate_gloves"
	materials = /datum/material/iron

/obj/item/clothing/gloves/plate_gloves/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/shoes/plate_boots
	name = "plate boots"
	desc = "The boots."
	worn_icon = 'dwarfs/icons/mob/clothing/feet.dmi'
	worn_icon_state = "sabatons"
	icon = 'dwarfs/icons/items/clothing/feet.dmi'
	icon_state = "plate_boots"
	materials = /datum/material/iron

/obj/item/clothing/shoes/plate_boots/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/item/clothing/shoes/boots
	name = "boots"
	desc = "So small a child can wear them."
	icon = 'dwarfs/icons/items/clothing/feet.dmi'
	icon_state = "boots"
	inhand_icon_state = "boots"
	worn_icon = 'dwarfs/icons/mob/clothing/feet.dmi'
	worn_icon_state = "boots"

/obj/item/clothing/under/tunic
	name = "tunic"
	desc = "Typical tunic. Smells of alcohol."
	worn_icon = 'dwarfs/icons/mob/clothing/under.dmi'
	worn_icon_state = "tunic_brown"
	icon = 'dwarfs/icons/items/clothing/under.dmi'
	icon_state = "tunic_brown"

/obj/item/clothing/under/tunic/Initialize(mycolor=null)
	. = ..()
	select_color("white")

/obj/item/clothing/under/tunic/random/Initialize(mycolor=null)
	. = ..()
	select_color(mycolor)

/obj/item/clothing/under/tunic/proc/select_color(mycolor=null)
	if(!mycolor)
		mycolor = pick("brown","red","yellow","green","aqua","blue","purple","white","gray","black")
	worn_icon_state = "tunic_[mycolor]"
	icon_state = "tunic_[mycolor]"
	name = "[mycolor] [initial(name)]"

/obj/item/clothing/under/loincloth
	name = "loincloth"
	desc = "A few pieces of fabric barely holding together."
	worn_icon = 'dwarfs/icons/mob/clothing/under.dmi'
	worn_icon_state = "loincloth"
	icon = 'dwarfs/icons/items/clothing/under.dmi'
	icon_state = "loincloth"
	body_parts_covered = GROIN|LEGS

/obj/item/clothing/shoes/leather_boots
	name = "leather boots"
	desc = "Sturdy boots made of leather. Slightly better than regular cloth boots."
	icon_state = "leather_boots"
	icon = 'dwarfs/icons/items/clothing/feet.dmi'

/obj/item/clothing/gloves/leather
	name = "leather gloves"
	desc = "Decent protection for your fingers."
	icon_state = "leather_gloves"
	icon = 'dwarfs/icons/items/clothing/gloves.dmi'

/obj/item/clothing/suit/leather_vest
	name = "leather vest"
	desc = "A vest made of leather. Light and gives good enough protection."
	icon_state = "leather_vest"
	icon = 'dwarfs/icons/items/clothing/suit.dmi'
	body_parts_covered = CHEST | ARMS
	allowed = TRUE

/obj/item/clothing/head/leather_helmet
	name = "leather_helmet"
	desc = "A leather helmet. Protects your brain from goblin clubs."
	icon_state = "leather_helmet"
	icon = 'dwarfs/icons/items/clothing/head.dmi'
