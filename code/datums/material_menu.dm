/datum/browser/modal/material_menu/New(nuser, nwindow_id, ntitle, nwidth, nheight, atom/nref, StealFocus, Timeout)
	. = ..()
	add_script("materialmenujs", 'html/material_menu.js')
	set_content(build_menu())

/datum/browser/modal/material_menu/proc/build_options(part_name=PART_NONE, selected_material)
	. = list("<select name='[part_name]-select' id='[part_name]' class='part_select'>")
	for(var/mtype in SSmaterials.materials)
		var/datum/material/M = SSmaterials.materials[mtype]
		. += "<option [mtype == selected_material ? "selected='selected'" : ""] value='[mtype]'>[M.name] - [mtype]</option>"
	. += "</select>"

/datum/browser/modal/material_menu/proc/build_menu()
	var/list/dat = list()
	var/atom/parent = ref.resolve()
	if(islist(parent.materials))
		for(var/part_name in parent.materials)
			dat += "<br><label for='[part_name]-select'>[part_name]:</label>"
			dat += build_options(part_name, parent.materials[part_name])
	else
		dat += "<br>"
		dat += build_options(selected_material=parent.materials)
	if(isobj(parent))
		var/obj/O = parent
		dat += "<br><label for='grade_input'>Grade(1-6):</label>"
		dat += "<input type='number' min='1' max='6' name='grade_input' id='grade_input' class='grade_select' value='[O.grade]'>"
	dat += "<br><center><button onclick='send_topic(\"\ref[src]\")'>Update</button></center>"
	return dat.Join("")

/datum/browser/modal/material_menu/Topic(href, list/href_list)
	. = ..()
	if(href_list["update"])
		if(!check_rights(R_VAREDIT))
			close()
			return
		var/list/new_materials = list()
		var/atom/parent = ref.resolve()
		var/list/selected_materials = href_list["materials"]
		var/list/selected_parts = href_list["parts"]
		var/grade
		if(isobj(parent))
			grade = text2num(href_list["grade"])
		if(islist(selected_materials))
			for(var/i in 1 to LAZYLEN(selected_materials))
				var/material = text2path(selected_materials[i])
				var/part = selected_parts[i]
				new_materials[part] = material
		else
			new_materials = text2path(selected_materials)
		parent.apply_material(new_materials)
		parent.update_stats(grade)
