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

/datum/material/proc/apply2icon_default(_icon, _icon_state)
	var/icon/I = icon(_icon, _icon_state)
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
	force_mod = 1.2
	toolspeed_mod = 0.5
	slowdown_mod = 1
	melee_cd_mod = 1.1

/datum/material/wood
	name = "wood"
	palettes = list("wood_treated")
	force_mod = 0.5
	toolspeed_mod = 1.2
	slowdown_mod = 0
	melee_cd_mod = 0.8
