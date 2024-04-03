/datum/outfit/dwarf/debug
	name = "Dwarf debug"
	back = /obj/item/storage/satchel/debug/filled

/datum/outfit/dwarf/debug/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(!visualsOnly)
		for(var/S in subtypesof(/datum/skill))
			H.set_experience(S,SKILL_EXP_LEGEND, TRUE)
			var/datum/skill/skill = H.get_skill(S)
			skill.admin_spawned = TRUE

/obj/item/storage/satchel/debug
	name = "Satchel of holding"

/obj/item/storage/satchel/debug/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = INFINITY
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_items = INFINITY

/obj/item/storage/satchel/debug/filled

/obj/item/storage/satchel/debug/filled/PopulateContents()
	. = ..()
	var/obj/O
	var/obj/item/stack/S
	O = new /obj/item/pickaxe(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
	O = new /obj/item/shovel(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
	O = new /obj/item/builder_hammer(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
	O = new /obj/item/smithing_hammer(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
	O = new /obj/item/tongs(src)
	O.apply_material(/datum/material/adamantine);O.update_stats(6)
	O = new /obj/item/hoe(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
	O = new /obj/item/axe(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
	S = new /obj/item/stack/sheet/stone(src)
	S.apply_material(/datum/material/stone);S.amount = 50
	S = new /obj/item/stack/sheet/planks(src)
	S.apply_material(/datum/material/wood/treated);S.amount = 50
	O = new /obj/item/chisel(src)
	O.apply_material(list(PART_HANDLE=/datum/material/wood/treated, PART_HEAD=/datum/material/adamantine));O.update_stats(6)
