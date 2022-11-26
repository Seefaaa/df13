#define symbol_path 'dwarfs/icons/structures/sign_symbols.dmi'
/obj/structure/sign
	name = "sign"
	var/sign_text = "test"
	var/text_color = "#f5c60c"
	icon = 'dwarfs/icons/structures/sign.dmi'
	icon_state = "sign_stone"
	var/add_decal_1 = "none"
	var/add_decal_2 = "none"
	var/picked_color
	var/mutable_appearance/decal_overlay_1
	var/mutable_appearance/decal_overlay_2
	var/mutable_appearance/scribbels
	var/static/list/sign_decals = list("pickaxe","arrow_right","arrow_left","dwarf","shovel","hammer","axe","hoe","cross","goblin","circle","sword","cauldron","bucket","cat","mug","anvil","meat","tombstone", "none")

/obj/structure/sign/proc/write(var/txt as text, var/decal_1, var/decal_2, var/picked_color)
	sign_text = txt
	cut_overlays()
	text_color = picked_color
	if(sign_text)
		scribbels = mutable_appearance(icon,"scribbels")
		scribbels.color = text_color
		add_overlay(scribbels)
	if(decal_1 && decal_1 != "none")
		decal_overlay_1 = mutable_appearance(symbol_path, decal_1)
		decal_overlay_1.color = text_color
		decal_overlay_1.pixel_x = 7
		decal_overlay_1.pixel_y = 15
		add_overlay(decal_overlay_1)
	if(decal_2 && decal_2 != "none")
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
		ui_interact(usr)
		// var/to_write = input(usr,"What would you like to write?") as text
		// var/add_decal_1 = tgui_alert(usr,"Add decal 1", "question", sign_decals + "None")
		// var/add_decal_2 = tgui_alert(usr,"Add decal 2", "question", sign_decals + "None")
		return

/obj/structure/sign/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sign", "Sign")
		ui.open()
		ui.set_autoupdate(TRUE)

/obj/structure/sign/ui_data(mob/user)
	. = ..()
	.["decals"] = sign_decals
	.["text"] = sign_text
	.["selected_decal_1"] = add_decal_1
	.["selected_decal_2"] = add_decal_2

/obj/structure/sign/ui_act(action, params, datum/tgui/ui)
	. = ..()
	switch(action)
		if("set_decal_1")
			add_decal_1 = params["selected_decal_1"]
			ui_interact(usr, ui)
		if("set_decal_2")
			add_decal_2 = params["selected_decal_2"]
			ui_interact(usr, ui)
		if("pick_color")
			picked_color = input(usr,"What color?") as color
			ui_interact(usr, ui)
		if("write")
			var/obj/item/chisel/I = usr.get_active_held_item()
			if(!istype(I))
				to_chat(usr,span_alert("You need to be holding a chisel"))
				return
			if(I.use_tool(src, usr, 5, volume=50))
				write(params["text"], add_decal_1, add_decal_2, picked_color)
			ui.close()

