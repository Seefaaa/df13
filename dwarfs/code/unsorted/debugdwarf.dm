/datum/outfit/dwarf/debug
	name = "Dwarf debug"
	back = /obj/item/storage/satchel/debug/filled
	apply_grade = TRUE


/datum/outfit/dwarf/debug/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(!visualsOnly)
		for(var/S in subtypesof(/datum/skill))
			H.set_experience(S,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/martial,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/logging,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/farming,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/butchering,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/cooking,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/combat,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/skinning,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/smithing,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/masonry,SKILL_EXP_LEGEND, TRUE)
		// H.set_experience(/datum/skill/construction,SKILL_EXP_LEGEND, TRUE)

/obj/item/storage/satchel/debug
	name = "Satchel of holding"

/obj/item/pickaxe/high_grade
	grade = 6

/obj/item/axe/high_grade
	grade = 6

/obj/item/storage/satchel/debug/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = INFINITY
	STR.max_w_class = WEIGHT_CLASS_HUGE
	STR.max_items = INFINITY

/obj/item/storage/satchel/debug/filled

/obj/item/storage/satchel/debug/filled/PopulateContents()
	. = ..()
	new /obj/item/pickaxe/high_grade(src)
	new /obj/item/shovel(src)
	new /obj/item/builder_hammer(src)
	new /obj/item/smithing_hammer(src)
	new /obj/item/trowel(src)
	new /obj/item/tongs(src)
	new /obj/item/hoe(src)
	new /obj/item/axe/high_grade(src)
	new /obj/item/stack/sheet/stone/fifty(src)
	new /obj/item/stack/sheet/planks/fifty(src)
	new /obj/item/chisel(src)

/obj/item/stack/sheet/stone/fifty
	amount = 50

/obj/item/stack/sheet/planks/fifty
	amount = 50
