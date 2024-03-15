/*****************Pickaxes & Drills & Shovels****************/
/obj/item/pickaxe
	name = "pickaxe"
	desc = "Strike the earth!"
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "pickaxe"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	force = 15
	atck_type = PIERCE
	throwforce = 10
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	tool_behaviour = TOOL_PICKAXE
	toolspeed = 1.5
	usesound = list('sound/effects/picaxe1.ogg', 'sound/effects/picaxe2.ogg', 'sound/effects/picaxe3.ogg')
	attack_verb_continuous = list("hits", "pierces", "slashes", "attacks")
	attack_verb_simple = list("hit", "pierce", "slash", "attacks")
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)
	var/hardness = 1

/obj/item/pickaxe/build_material_icon(_file, state)
	var/icon/I = ..()
	I = apply_palettes(I, list(materials[PART_HANDLE], materials[PART_HEAD]))
	return I

/obj/item/pickaxe/apply_material_stats()
	var/datum/material/M = get_material(materials[PART_HEAD])
	hardness = M.hardness
	. = ..()

/obj/item/pickaxe/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging into [user.p_their()] chest! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/shovel
	name = "shovel"
	desc = "Shovel made for excavating soils."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "shovel"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	force = 8
	tool_behaviour = TOOL_SHOVEL
	toolspeed = 1
	usesound = 'sound/effects/shovel_dig.ogg'
	throwforce = 4
	inhand_icon_state = "shovel"
	w_class = WEIGHT_CLASS_BULKY
	attack_verb_continuous = list("smashes", "hits", "attacks")
	attack_verb_simple = list("smash", "hit", "attack")
	atck_type = SHARP
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)
	var/hardness = 1

/obj/item/shovel/Initialize()
	. = ..()
	AddComponent(/datum/component/butchering, 150) //it's sharp, so it works, but barely.

/obj/item/shovel/apply_material_stats()
	var/datum/material/M = get_material(materials[PART_HEAD])
	hardness = M.hardness
	. = ..()

/obj/item/shovel/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] begins digging their own grave! It looks like [user.p_theyre()] trying to commit suicide!"))
	if(use_tool(user, user, 30, volume=50))
		return BRUTELOSS
	user.visible_message(span_suicide("[user] couldn't do it!"))
	return SHAME

/obj/item/shovel/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/axe
	name = "axe"
	desc = "A common tool for chopping down trees."
	icon = 'dwarfs/icons/items/tools.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "axe"
	tool_behaviour = TOOL_AXE
	force = 10
	throwforce = 5
	atck_type = SHARP
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = 'dwarfs/sounds/tools/axe/axe_chop.ogg'
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)

/obj/item/axe/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/smithing_hammer
	name = "smithing hammer"
	desc = "Used for forging."
	icon = 'dwarfs/icons/items/tools.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	icon_state = "smithing_hammer"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	force = 20
	throwforce = 25
	throw_range = 4
	atck_type = BLUNT
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)

/obj/item/smithing_hammer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	..()
	if(iswallturf(target) && proximity_flag)
		user.changeNext_move(CLICK_CD_MELEE)
		var/turf/closed/wall/W = target
		var/chance = (W.hardness * 0.5)
		if(chance < 10)
			return FALSE

		if(prob(chance))
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			W.dismantle_wall(TRUE)

		else
			playsound(src, 'sound/effects/bang.ogg', 50, 1)
			W.add_dent(WALL_DENT_HIT)
			visible_message(span_danger("<b>[user]</b> hits the <b>[W]</b> with [src]!") , null, COMBAT_MESSAGE_RANGE)
	return TRUE

/obj/item/smithing_hammer/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/chisel
	name = "chisel"
	desc = "Chisel, used by masons to process stone goods."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "chisel"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = 'dwarfs/sounds/tools/chisel/chisel_hit.ogg'
	tool_behaviour = TOOL_CHISEL
	atck_type = PIERCE
	w_class = WEIGHT_CLASS_SMALL
	force = 10
	throwforce = 12
	throw_range = 7
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)
	/// Flag that controls whether we chisel big tiles frol rock floor or regular tiles
	var/chisel_bigtiles = FALSE

/obj/item/chisel/examine(mob/user)
	. = ..()
	. += "<br>It's set to chisel [chisel_bigtiles ? "big" : "regular"] tiles."

/obj/item/chisel/attack_self(mob/user, modifiers)
	chisel_bigtiles = !chisel_bigtiles
	to_chat(user, span_notice("You will now chisel [chisel_bigtiles ? "big" : "regular"] tiles."))

/obj/item/chisel/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/tongs
	name = "tongs"
	desc = "Essential tool for smithing."
	icon = 'dwarfs/icons/items/tools.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	inhand_icon_state = "tongs"
	worn_icon_state = "tongs"
	icon_state = "tongs_open"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	force = 4
	atck_type = BLUNT
	throwforce = 6
	throw_range = 7
	materials = /datum/material/copper

/obj/item/tongs/build_material_icon(_file, state)
	var/icon/I = ..()
	var/datum/material/M = get_material(materials)
	return M.apply2icon_default(I)

/obj/item/tongs/tool_use_check(mob/living/user, amount)
	return contents.len

/obj/item/tongs/update_icon_state()
	. = ..()
	if(contents.len)
		icon_state = "tongs_closed"
	else
		icon_state = "tongs_open"

/obj/item/tongs/update_overlays()
	. = ..()
	if(contents.len)
		var/obj/item/ingot/I = contents[1]
		var/icon/Ingot = I.get_material_icon('dwarfs/icons/items/tools.dmi', "tongs_ingot")
		. += Ingot
		var/mutable_appearance/Ingot_heat = mutable_appearance('dwarfs/icons/items/tools.dmi', "tongs_ingot_heat")
		Ingot_heat.color = "#ff9900"
		Ingot_heat.alpha =  255 * (I.heattemp / 350)
		. += Ingot_heat

/obj/item/tongs/worn_overlays(isinhands, icon_file)
	. = ..()
	if(contents.len)
		var/obj/item/ingot/I = contents[1]
		var/icon/Ingot = I.get_material_icon(icon_file, "tongs_ingot")
		. += Ingot
		var/mutable_appearance/Ingot_heat = mutable_appearance(icon_file, "tongs_ingot_heat")
		Ingot_heat.color = "#ff9900"
		Ingot_heat.alpha =  255 * (I.heattemp / 350)
		. += Ingot_heat

/obj/item/tongs/update_appearance(updates)
	. = ..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/tongs/attack_self(mob/user)
	. = ..()
	if(contents.len)
		var/obj/O = contents[contents.len]
		O.forceMove(drop_location())
		update_appearance()

/obj/item/trowel
	name = "trowel"
	desc = "Used for building purposes."
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "trowel"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	usesound = 'dwarfs/sounds/tools/trowel/trowel_dig.ogg'
	w_class = WEIGHT_CLASS_SMALL
	force = 8
	atck_type = PIERCE
	throwforce = 12
	throw_range = 3
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)

/obj/item/trowel/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))

/obj/item/hoe
	name = "hoe"
	desc = "Till the earth!"
	tool_behaviour = TOOL_HOE
	usesound = 'dwarfs/sounds/tools/hoe/hoe_dig.ogg'
	icon = 'dwarfs/icons/items/tools.dmi'
	icon_state = "hoe"
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_SUITSTORE
	w_class = WEIGHT_CLASS_BULKY
	atck_type = PIERCE
	force = 7
	materials = list(PART_HANDLE=/datum/material/wood/towercap/treated, PART_HEAD=/datum/material/copper)

/obj/item/hoe/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_HANDLE], materials[PART_HEAD]))
