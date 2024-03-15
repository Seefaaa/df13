/obj/structure/chair/stone
	name = "stone chair"
	desc = "Not so comfy."
	icon = 'dwarfs/icons/structures/chairs.dmi'
	icon_state = "stonechair"
	resistance_flags = LAVA_PROOF
	max_integrity = 150
	materials = list(PART_STONE=/datum/material/stone)
	buildstacktype = /obj/item/stack/sheet/stone

/obj/structure/chair/stone/build_material_icon(_file, state)
	return apply_palettes(..(), materials)

/obj/structure/chair/stone/GetArmrest()
	return mutable_appearance(icon, "stonechair_armrest")

/obj/structure/chair/stone/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		user.visible_message(span_notice("[user] tries to disasseble stone chair using <b>wrench</b>.") , \
		span_notice("You try to disassemble stone chair..."))
		return
	else
		return ..()

/obj/structure/chair/stone/throne
	name = "stone throne"
	desc = "Amazing looks, still not very comfy."
	icon = 'dwarfs/icons/structures/chairs.dmi'
	icon_state = "throne"
	max_integrity = 650

/obj/structure/chair/stone/throne/GetArmrest()
	return mutable_appearance('dwarfs/icons/structures/chairs.dmi', "throne_armrest")
