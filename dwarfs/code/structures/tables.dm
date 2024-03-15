/obj/structure/table/stone
	name = "stone table"
	desc = "Caveman technology, but at least you can eat on it."
	icon = 'dwarfs/icons/structures/stone_table.dmi'
	icon_state = "stone_table-0"
	base_icon_state = "stone_table"
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 300
	materials = list(PART_STONE=/datum/material/stone)
	buildstack = /obj/item/stack/sheet/stone

/obj/structure/table/stone/apply_material(list/_materials)
	. = ..()
	icon = materials[PART_STONE] == /datum/material/stone ? 'dwarfs/icons/structures/stone_table.dmi' : 'dwarfs/icons/structures/sand_table.dmi'

/obj/structure/table/wood
	name = "wooden table"
	desc = "It's a table."
	icon = 'dwarfs/icons/structures/wood_table.dmi'
	icon_state = "wood_table-0"
	base_icon_state = "wood_table"
	buildstack = /obj/item/stack/sheet/planks
	materials = /datum/material/wood/pine/treated

/obj/structure/table/wood/build_material_icon(_file, state)
	return apply_palettes(..(), materials)
