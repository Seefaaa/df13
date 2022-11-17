#define symbol_path 'dwarfs/icons/structures/sign_symbols.dmi'

GLOBAL_LIST_INIT(sign_decals,list("pickaxe","arrow_right","arrow_left","dwarf"))

/obj/structure/sign
	name = "sign"
	var/sign_text = "test"
	var/text_color = "#f5c60c"
	icon = 'dwarfs/icons/structures/sign.dmi'
	icon_state = "sign_stone"
	var/mutable_appearance/decal_overlay_1
	var/mutable_appearance/decal_overlay_2
	var/mutable_appearance/scribbels

/obj/structure/sign/proc/write(var/txt as text, var/decal_1, var/decal_2, var/picked_color)
	sign_text = txt
	cut_overlays()
	text_color = picked_color
	if(sign_text)
		scribbels = mutable_appearance(icon,"scribbels")
		scribbels.color = text_color
		add_overlay(scribbels)
	if(decal_1 && decal_1 != "None")
		decal_overlay_1 = mutable_appearance(symbol_path, decal_1)
		decal_overlay_1.color = text_color
		decal_overlay_1.pixel_x = 7
		decal_overlay_1.pixel_y = 15
		add_overlay(decal_overlay_1)
	if(decal_2 && decal_2 != "None")
		decal_overlay_2 = mutable_appearance(symbol_path, decal_2)
		decal_overlay_2.color = text_color
		decal_overlay_2.pixel_x = 17
		decal_overlay_2.pixel_y = 15
		add_overlay(decal_overlay_2)

/obj/structure/sign/examine(mob/user)
	. = ..()
	. += "<hr><span style='color:[text_color]'>[sign_text]</span>"

/obj/structure/sign/attacked_by(obj/item/I, mob/living/user)
	if(istype(I,/obj/item/chisel))
		var/to_write = input(usr,"What would you like to write?") as text
		var/add_decal_1 = tgui_alert(usr,"Add decal 1", "question", GLOB.sign_decals + "None")
		var/add_decal_2 = tgui_alert(usr,"Add decal 2", "question", GLOB.sign_decals + "None")
		var/picked_color = input(usr,"What color?") as color
		if(I.use_tool(src, user, 5, volume=50))
			write(to_write, add_decal_1, add_decal_2,picked_color)
			return
	. = ..()
