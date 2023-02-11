/datum/material
	/// Material name. Displayed in examine etc.
	var/name = "material"
	/// Palettes used. Used as icon_states for it's palette at 'dwarfs/icons/palettes.dmi'. Depending on amount of materials will use template palettes in increasing order.
	var/list/palettes = list("material")
	/// Force multiplier
	var/force_mod = 1
	/// Tool spped multiplier
	var/toolspeed_mod = 1
	/// Health multiplier for structures
	var/integrity_mod = 1
	/// Click cd cooldown multiplier
	var/melee_cd_mod = 1
	/// Slowdown modifier (additive). Remember that negative values speed up
	var/slowdown_mod = 0

	// Armor multipliers
	var/armor_sharp_mod = 1
	var/armor_pierce_mod = 1
	var/armor_blunt_mod = 1
	var/armor_fire_mod = 1
	var/armor_acid_mod = 1
	var/armor_magic_mod = 1
	var/armor_wound_mod = 1
	// Armor penetration multipliers
	var/armorpen_sharp_mod = 1
	var/armorpen_pierce_mod = 1
	var/armorpen_blunt_mod = 1
	var/armorpen_fire_mod = 1
	var/armorpen_acid_mod = 1
	var/armorpen_magic_mod = 1

/**
 * Applies stat modifiers a given material has to an obj
 *
 * Argumens:
 * - A: The obj we are applying this material to.
 */
/datum/material/proc/apply_stats(obj/A)
	if(isitem(A))
		var/obj/item/I = A
		I.force *= force_mod
		I.toolspeed *= toolspeed_mod
		I.melee_cd *= melee_cd_mod
		I.slowdown += slowdown_mod
		if(I.armor_penetration)
			I.armor_penetration.sharp *= armorpen_sharp_mod
			I.armor_penetration.pierce *= armorpen_pierce_mod
			I.armor_penetration.blunt *= armorpen_blunt_mod
			I.armor_penetration.fire *= armorpen_fire_mod
			I.armor_penetration.acid *= armorpen_acid_mod
			I.armor_penetration.magic *= armorpen_magic_mod
	if(A.armor)
		A.armor.sharp *= armor_sharp_mod
		A.armor.pierce *= armor_pierce_mod
		A.armor.blunt *= armor_blunt_mod
		A.armor.fire *= armor_fire_mod
		A.armor.acid *= armor_acid_mod
		A.armor.magic *= armor_magic_mod
		A.armor.wound *= armor_wound_mod
//TODO: add functions that prevent armor and penetration reaching 100%
//TODO: add functions that prevent melee cd reaching near zero values; same with toolspeed

/datum/material/proc/apply2icon_default(icon/I)
	for(var/i in 1 to palettes.len)
		I = apply_palette(I, "template[i]", palettes[i])
	return I

/**
 * Applies palette to given template for an icon
 *
 * Argumens:
 * - I: The icon we are working with.
 * - template_name: icon_state of the template we are replacing.
 * - palette_name: icon_state of the material we want to apply. This defaults to the first element of this material.
 */
/datum/material/proc/apply_palette(icon/I, template_name, palette_name=null)
	palette_name = palette_name ? palette_name : palettes[1]
	. = I
	var/icon/template_palette = SSmaterials.palettes[template_name]
	var/icon/material_palette = SSmaterials.palettes[palette_name]

	for(var/x in 1 to 9)
		var/color_old = template_palette.GetPixel(x, 1)
		var/color_new = material_palette.GetPixel(x, 1)
		I.SwapColor(color_old, color_new)

/**
 * Applies materials with given palettes to an icon
 *
 * Argumens:
 * - I: The icon we are working with.
 * - materials: list of material types. Place the types in the correct oder according to what templates will be used.
 */
/proc/apply_palettes(icon/I, list/materials)
	for(var/i in 1 to materials.len)
		var/datum/material/M = SSmaterials.materials[materials[i]]
		I = M.apply_palette(I, "template[i]")
	return I

/datum/material/iron
	name = "iron"
	palettes = list("iron")

/datum/material/gold
	name = "gold"
	palettes = list("gold")
	force_mod = 0.9
	slowdown_mod = 2
	melee_cd_mod = 1.2

/datum/material/wood
	name = "wood"
	palettes = list("wood_treated")
	force_mod = 0.5
	toolspeed_mod = 1.2
	slowdown_mod = 0
	melee_cd_mod = 0.8
