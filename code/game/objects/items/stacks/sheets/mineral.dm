/*
Mineral Sheets
	Contains:
		- Diamond
		- Gold
		- Silver
	Others:
		- Coal
*/


/*
 * Diamond
 */

/obj/item/stack/sheet/mineral/gem
	max_amount = 1
	novariants = TRUE
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'

/obj/item/stack/sheet/mineral/gem/diamond
	name = "diamond"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "diamond"
	// inhand_icon_state = "sheet-diamond"
	singular_name = "diamond"
	merge_type = /obj/item/stack/sheet/mineral/gem/diamond

/obj/item/stack/sheet/mineral/gem/sapphire
	name = "sapphire"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "sapphire"
	// inhand_icon_state = "sheet-sapphire"
	singular_name = "sapphire"
	merge_type = /obj/item/stack/sheet/mineral/gem/sapphire

/obj/item/stack/sheet/mineral/gem/ruby
	name = "ruby"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "ruby"
	// inhand_icon_state = "sheet-ruby"
	singular_name = "ruby"
	merge_type = /obj/item/stack/sheet/mineral/gem/ruby

/*
 * Gold
 */
/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "sheet-gold"
	inhand_icon_state = "sheet-gold"
	singular_name = "golden sheet"
	merge_type = /obj/item/stack/sheet/mineral/gold
	novariants = TRUE

GLOBAL_LIST_INIT(gold_recipes, list ())

/obj/item/stack/sheet/mineral/gold/get_main_recipes()
	. = ..()
	. += GLOB.gold_recipes
