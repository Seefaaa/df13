/obj/structure/alloy_smelter
	name = "alloy smelter"
	desc = "A furnace made to produce pig iron and other alloys."
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "bf_empty_bars"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	light_range = 2
	light_color = "#BB661E"
	materials = list(PART_INGOT=/datum/material/iron, PART_STONE=/datum/material/stone)
	/// How much 'fuel' is inside
	var/fuel = 0
	/// How much fuel we consume per second
	var/fuel_consumption = 0.5
	/// Whether we have flux inside
	var/flux = FALSE
	/// Whether it's lit
	var/working = FALSE
	/// Whether the fuel opening is open. Closed by default
	var/open = FALSE
	/// Particle source since we use two layers for the structure
	var/obj/particle_source
	/// Current smelting timer id
	var/timerid

/obj/structure/alloy_smelter/Initialize()
	. = ..()
	particle_source = new/obj()
	particle_source.icon = icon
	particle_source.icon_state = "bf_upper"
	particle_source.vis_flags = VIS_INHERIT_ID
	particle_source.layer = ABOVE_MOB_LAYER
	particle_source.particles = new/particles/smoke/alloy_smelter
	vis_contents += particle_source
	set_light_on(working)
	update_light()
	update_appearance()

/obj/structure/alloy_smelter/Destroy()
	QDEL_NULL(particle_source)
	. = ..()

/obj/structure/alloy_smelter/build_material_icon(_file, state)
	return apply_palettes(..(), list(materials[PART_INGOT], materials[PART_STONE]))

/obj/structure/alloy_smelter/apply_material(list/_materials)
	. = ..()
	particle_source.icon = icon

/obj/structure/alloy_smelter/examine(mob/user)
	. = ..()
	if(working)
		. += "<br>It's is working."
	if(!fuel)
		. += "<br>It's missing fuel."
	else
		. += "<br>It has fuel inside."
	if(contents.len)
		var/list/contents_text = list()
		for(var/obj/item/I in contents)
			var/amount = 1
			if(isstack(I))
				var/obj/item/stack/S = I
				amount = S.amount
			contents_text += " [amount > 1 ? "[amount] " : ""][I]"
		. += "<br> It has[contents_text.Join(", ")] inside."
	var/smithing_level = user.get_skill_level(/datum/skill/smithing)
	if(!flux && smithing_level > 5)
		. += "<br>It's missing flux."
	else if(flux && smithing_level > 5)
		. += "<br>It has flux inside."
	. += span_notice("<hr>Alt-click to toggle open.")

/obj/structure/alloy_smelter/update_icon_state()
	. = ..()
	if(working)
		icon_state = "bf_working"
	else
		if(fuel)
			icon_state = "bf_coal"
		else
			icon_state = "bf_empty"

/obj/structure/alloy_smelter/update_overlays()
	. = ..()
	if(!open)
		var/mutable_appearance/bars = mutable_appearance(icon, "bf_bars")
		. += bars

/obj/structure/alloy_smelter/AltClick(mob/user)
	if(!CanReach(user))
		return
	// disabled this cause it can cause players to soft lock their smelter
	// if(working)
	// 	to_chat(user, span_warning("Cannot [open ? "close" : "open"] [src] while it's working."))
	// 	return
	open = !open
	update_appearance()
	to_chat(user, span_notice("You [open ? "open" : "close"] [src]."))
	playsound(src, 'dwarfs/sounds/structures/toggle_open.ogg', 50, TRUE)

/obj/structure/alloy_smelter/attackby(obj/item/I, mob/user, params)
	var/can_accept = can_accept_item(I) //precall it so we don't have to call it multiple times to get the result in a var later on
	if(istype(I, /obj/item/stack/sheet/flux))
		if(!open)
			to_chat(user, span_warning("You need to open \the [src] first."))
			return
		if(flux)
			to_chat(user, span_warning("There's already flux inside [src]."))
			return
		var/obj/item/stack/F = I
		F.use(1)
		to_chat(user, span_notice("You add [F] into [src]."))
		flux = TRUE
	else if((!isnull(can_accept) && !I.get_fuel()) || (can_accept != 0 && can_accept != null && I.get_fuel()))
		if(!open)
			to_chat(user, span_warning("You need to open \the [src] first."))
			return
		if(can_accept == 0)
			to_chat(user, span_warning("There's already enough of [I] inside [src]."))
			return
		add_item(I)
		to_chat(user, span_notice("You add [I] into [src]."))
		update_appearance()
		if(!working)
			return
		var/datum/alloy_recipe/R = get_alloy_recipe()
		if(R)
			timerid = addtimer(CALLBACK(src, PROC_REF(smelt), user, R), flux ? R.smelting_time : R.smelting_time * 2, TIMER_STOPPABLE)
	else if(I.get_temperature())
		if(open)
			to_chat(user, span_warning("You need to close \the [src] first."))
			return
		if(working)
			to_chat(user, span_warning("\The [src] is already lit."))
			return
		if(!fuel)
			to_chat(user, span_warning("\The [src] is missing fuel to start."))
			return
		to_chat(user, span_notice("You light up [src]."))
		playsound(src, 'dwarfs/sounds/effects/ignite.ogg', 50, TRUE)
		working = TRUE
		particle_source.particles.spawning = 0.5
		START_PROCESSING(SSprocessing, src)
		set_light_on(working)
		update_light()
		update_appearance()
		var/datum/alloy_recipe/R = get_alloy_recipe()
		if(R)
			timerid = addtimer(CALLBACK(src, PROC_REF(smelt), user, R), flux ? R.smelting_time : R.smelting_time * 2, TIMER_STOPPABLE)
	else if(I.get_fuel())
		if(!open)
			to_chat(user, span_warning("You need to open \the [src] first."))
			return
		if(fuel)
			to_chat(user, span_warning("There's already fuel inside [src]."))
			return
		to_chat(user, span_notice("You throw [I] into [src]."))
		fuel += I.get_fuel()
		qdel(I)
		update_appearance()
	else
		. = ..()

/// Returns required amount of this item if any of the alloy recipes can accept that item, if none can accept it, returns null
/obj/structure/alloy_smelter/proc/can_accept_item(obj/item/I)
	. = null
	for(var/datum/alloy_recipe/R in SSmaterials.alloy_recipes)
		var/res = R.can_accept_item(I, contents)
		if(!isnull(res))
			return res

/// Helper to add items to contents. Don't move them there manually
/obj/structure/alloy_smelter/proc/add_item(obj/item/I)
	if(isstack(I))
		var/obj/item/stack/S = I
		for(var/obj/item/IC in contents)
			if(I.type == IC.type && I.materials == IC.materials)
				var/obj/item/stack/SC = IC
				SC.add(1)
				S.use(1)
				return
		var/obj/item/stack/SC = new I.type(src)
		SC.apply_material(I.materials)
		S.use(1)
	else
		I.forceMove(src)

/// Returns an alloy_recipe datum if a match is found, otherwise returns null. Unless we're missing more materials, it shouldn't return null
/obj/structure/alloy_smelter/proc/get_alloy_recipe()
	for(var/datum/alloy_recipe/R in SSmaterials.alloy_recipes)
		if(R.are_reqs_fulfilled(contents))
			return R

/obj/structure/alloy_smelter/proc/smelt(mob/user, datum/alloy_recipe/R)
	user.adjust_experience(/datum/skill/smithing, R.exp_gain)
	for(var/i in 1 to R.result_amount)
		var/obj/O = new R.result(get_turf(src))
		O.apply_material(R.result_material)
	flux = FALSE
	working = FALSE
	contents.Cut()
	particle_source.particles.spawning = 0
	set_light_on(working)
	update_light()
	update_appearance()

/obj/structure/alloy_smelter/process(delta_time)
	if(!working)
		return PROCESS_KILL
	if(fuel == 0)
		working = FALSE
		deltimer(timerid)
		set_light_on(working)
		update_light()
		update_appearance()
	if(prob(20))
		playsound(src, 'dwarfs/sounds/effects/fire_cracking_short.ogg', 100, TRUE)
	fuel = max(fuel - fuel_consumption*delta_time, 0)
