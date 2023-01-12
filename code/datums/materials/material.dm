/datum/material
	/// Palettes used. Used as icon_states for it's palette at 'dwarfs/icons/palettes.dmi'. Depending on amount of materials will use template palettes in increasing order.
	var/list/palettes = list("material")

/**
 * Applies stat modifiers a given material has to an atom
 *
 * Argumens:
 * - A: The atom we are applying this material to.
 */
/datum/material/proc/apply_stats(atom/A)
	return

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

/datum/material/iron
	palettes = list("iron")

/datum/material/iron/tool_head

/datum/material/wood
	palettes = list("wood_treated")

/datum/material/wood/handle
