
#define ORESTACK_OVERLAYS_MAX 10

/**********************Mineral ores**************************/

/obj/item/stack/ore
	name = "rock"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "ore"
	full_w_class = WEIGHT_CLASS_BULKY
	singular_name = "ore chunk"
	var/mine_experience = 5 //How much experience do you get for mining this ore?
	novariants = TRUE // Ore stacks handle their icon updates themselves to keep the illusion that there's more going
	var/list/stack_overlays
	var/ore_icon  // icons for ore overlays
	var/ore_basename // basename for ore_icon
	var/datum/vein/vein_type // Type of vein this ore spawns in
	righthand_file = 'dwarfs/icons/mob/inhand/righthand.dmi'
	lefthand_file = 'dwarfs/icons/mob/inhand/lefthand.dmi'

/obj/item/stack/ore/update_overlays()
	. = ..()
	var/difference = min(ORESTACK_OVERLAYS_MAX, amount) - (LAZYLEN(stack_overlays)+1)
	if(difference == 0)
		return . += stack_overlays
	else if(difference < 0 && LAZYLEN(stack_overlays))			//amount < stack_overlays, remove excess.
		if (LAZYLEN(stack_overlays)-difference <= 0)
			stack_overlays = null
		else
			stack_overlays.len += difference
	else if(difference > 0)			//amount > stack_overlays, add some.
		for(var/i in 1 to difference)
			var/mutable_appearance/newore = mutable_appearance(icon, icon_state)
			newore.pixel_x = rand(-8,8)
			newore.pixel_y = rand(-8,8)
			LAZYADD(stack_overlays, newore)
	if (stack_overlays)
		. += stack_overlays

/obj/item/stack/ore/smeltable
	var/refined_type

/obj/item/stack/ore/smeltable/iron
	name = "iron ore"
	icon_state = "iron"
	singular_name = "iron ore chunk"
	mine_experience = 10
	merge_type = /obj/item/stack/ore/smeltable/iron
	ore_icon = 'dwarfs/icons/turf/ores/iron.dmi'
	ore_basename = "iron"
	vein_type = /datum/vein/line
	refined_type = /obj/item/ingot
	inhand_icon_state = "iron_ore"
	materials = /datum/material/iron

/obj/item/stack/ore/coal
	name = "coal"
	icon = 'dwarfs/icons/items/ores_gems.dmi'
	icon_state = "coal"
	singular_name = "coal chunk"
	mine_experience = 2
	merge_type = /obj/item/stack/ore/coal
	ore_icon = 'dwarfs/icons/turf/ores/coal.dmi'
	ore_basename = "coal"
	vein_type = /datum/vein/line

/obj/item/stack/ore/coal/get_fuel()
	return 15 * amount

/obj/item/stack/ore/coal/five
	amount = 5

/obj/item/stack/ore/coal/ten
	amount = 10

/obj/item/stack/ore/coal/fifty
	amount = 50

/obj/item/stack/ore/smeltable/gold
	name = "gold ore"
	icon_state = "gold"
	singular_name = "gold ore chunk"
	mine_experience = 12
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/gold.dmi'
	ore_basename = "gold"
	vein_type = /datum/vein/line
	inhand_icon_state = "gold_ore"
	materials = /datum/material/gold

/obj/item/stack/ore/smeltable/copper
	name = "malachite ore"
	icon_state = "malachite"
	inhand_icon_state = "malachite_ore"
	singular_name = "malachite ore chunk"
	mine_experience = 5
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/malachite.dmi'
	ore_basename = "malachite"
	vein_type = /datum/vein/line
	materials = /datum/material/copper

/obj/item/stack/ore/smeltable/silver
	name = "silver ore"
	icon_state = "silver"
	inhand_icon_state = "silver_ore"
	singular_name = "silver ore chunk"
	mine_experience = 7
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/silver.dmi'
	ore_basename = "silver"
	vein_type = /datum/vein/line
	materials = /datum/material/silver

/obj/item/stack/ore/smeltable/galena
	name = "galena ore"
	icon_state = "galena"
	inhand_icon_state = "galena_ore"
	singular_name = "galena ore chunk"
	mine_experience = 8
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/galena.dmi'
	ore_basename = "galena"
	vein_type = /datum/vein/line
	materials = /datum/material/lead

/obj/item/stack/ore/smeltable/platinum
	name = "platinum ore"
	icon_state = "platinum"
	inhand_icon_state = "platinum_ore"
	singular_name = "platinum ore chunk"
	mine_experience = 12
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/platinum.dmi'
	ore_basename = "platinum"
	vein_type = /datum/vein/line
	materials = /datum/material/platinum

/obj/item/stack/ore/smeltable/cassiterite
	name = "cassiterite ore"
	icon_state = "cassiterite"
	inhand_icon_state = "cassiterite_ore"
	singular_name = "cassiterite ore chunk"
	mine_experience = 8
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/cassiterite.dmi'
	ore_basename = "cassiterite"
	vein_type = /datum/vein/line
	materials = /datum/material/tin

/obj/item/stack/ore/smeltable/adamantine
	name = "adamantine ore"
	icon_state = "adamantine"
	inhand_icon_state = "adamantine_ore"
	singular_name = "adamantine ore chunk"
	mine_experience = 20
	refined_type = /obj/item/ingot
	ore_icon = 'dwarfs/icons/turf/ores/adamantine.dmi'
	ore_basename = "adamantine"
	vein_type = /datum/vein/line
	materials = /datum/material/adamantine

/obj/item/stack/ore/gem
	max_amount = 1
	var/cut_type

/obj/item/stack/ore/gem/diamond
	name = "diamond ore"
	icon_state = "diamond_uncut"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut diamond"
	cut_type = /obj/item/stack/sheet/mineral/gem/diamond
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/diamond
	ore_icon = 'dwarfs/icons/turf/ores/diamond.dmi'
	ore_basename = "diamond"
	vein_type = /datum/vein/cluster

/obj/item/stack/ore/gem/sapphire
	name = "sapphire ore"
	icon_state = "sapphire_uncut"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut sapphire"
	cut_type = /obj/item/stack/sheet/mineral/gem/sapphire
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/sapphire
	ore_icon = 'dwarfs/icons/turf/ores/sapphire.dmi'
	ore_basename = "sapphire"
	vein_type = /datum/vein/cluster

/obj/item/stack/ore/gem/ruby
	name = "ruby ore"
	icon_state = "ruby_uncut"
	// inhand_icon_state = "Diamond ore"
	singular_name = "uncut ruby"
	cut_type = /obj/item/stack/sheet/mineral/gem/ruby
	mine_experience = 10
	merge_type = /obj/item/stack/ore/gem/ruby
	ore_icon = 'dwarfs/icons/turf/ores/ruby.dmi'
	ore_basename = "ruby"
	vein_type = /datum/vein/cluster

/obj/item/stack/ore/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = base_pixel_x + rand(0, 16) - 8
	pixel_y = base_pixel_y + rand(0, 8) - 8

/obj/item/stack/ore/ex_act(severity, target)
	if (!severity || severity >= 2)
		return
	qdel(src)


#undef ORESTACK_OVERLAYS_MAX
