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

/datum/material/proc/apply_palette(icon/I, template_name, palette_name)
	. = I
	var/icon/template_palette = SSmaterials.palettes[template_name]
	var/icon/material_palette = SSmaterials.palettes[palette_name]

	for(var/x in 1 to 9)
		var/color_old = template_palette.GetPixel(x, 1)
		var/color_new = material_palette.GetPixel(x, 1)
		I.SwapColor(color_old, color_new)
