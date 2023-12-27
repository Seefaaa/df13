/obj/structure/blast_furnace
	name = "blast furnace"
	desc = "A furnace made to produce pig iron. Part of the steel making process."
	icon = 'dwarfs/icons/structures/32x64.dmi'
	icon_state = "bf_empty_bars"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	light_range = 2
	light_color = "#BB661E"
	materials = list(PART_INGOT=/datum/material/iron)
	/// Whether we have fuel inside
	var/fuel = FALSE
	/// Whether we have iron ore inside
	var/ore = FALSE
	/// Whether we have flux inside
	var/flux = FALSE
	/// Whether it's lit
	var/working = FALSE
	/// Whether the fuel opening is open. Closed by default
	var/open = FALSE
	/// Amount of time it takes to smelt its contents
	var/smelting_time = 10 SECONDS
	/// Particle source since we use two layers for the structure
	var/obj/particle_source

/obj/structure/blast_furnace/Initialize()
	. = ..()
	particle_source = new/obj()
	particle_source.icon = icon
	particle_source.icon_state = "bf_upper"
	particle_source.vis_flags = VIS_INHERIT_ID
	particle_source.layer = ABOVE_MOB_LAYER
	particle_source.particles = new/particles/smoke/blast_furnace
	vis_contents += particle_source
	set_light_on(working)
	update_light()
	update_appearance()

/obj/structure/blast_furnace/Destroy()
	QDEL_NULL(particle_source)
	. = ..()

/obj/structure/blast_furnace/build_material_icon(_file, state)
	return apply_palettes(..(), materials[PART_INGOT])

/obj/structure/blast_furnace/update_icon_state()
	. = ..()
	if(working)
		icon_state = "bf_working"
	else
		if(fuel && ore)
			icon_state = "bf_full"
		else if(fuel)
			icon_state = "bf_coal"
		else if(ore)
			icon_state = "bf_ore"
		else
			icon_state = "bf_empty"

/obj/structure/blast_furnace/update_overlays()
	. = ..()
	if(!working && !open)
		var/mutable_appearance/bars = mutable_appearance(icon, "bf_bars")
		. += bars

/obj/structure/blast_furnace/AltClick(mob/user)
	if(!CanReach(user))
		return
	if(working)
		to_chat(user, span_warning("Cannot [open ? "close" : "open"] [src] while it's working."))
		return
	open = !open
	update_appearance()
	to_chat(user, span_notice("You [open ? "open" : "close"] [src]."))
	playsound(src, 'dwarfs/sounds/structures/toggle_open.ogg', 50, TRUE)

/obj/structure/blast_furnace/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/ore/coal))///only coal can make pig iron
		if(!open)
			to_chat(user, span_warning("You need to open \the [src] first."))
			return
		if(fuel)
			to_chat(user, span_warning("There's already fuel inside [src]."))
			return
		var/obj/item/stack/C = I
		if(!C.use(2))
			to_chat(user, span_warning("You need at least 2 to fuel \the [src]."))
			return
		// we use 2 coal for 30 fuel. This might need proper system like I.use_fuel(30) later
		to_chat(user, span_notice("You throw [C] into [src]."))
		fuel = TRUE
		update_appearance()
	else if(istype(I, /obj/item/stack/sheet/flux))
		if(!open)
			to_chat(user, span_warning("You need to open \the [src] first."))
			return
		if(flux)
			to_chat(user, span_warning("There's already flux inside [src]."))
			return
		var/obj/item/stack/F = I
		F.use(1)
		to_chat(user, span_notice("You throw [F] into [src]."))
		flux = TRUE
	else if(istype(I, /obj/item/stack/ore/smeltable/iron))
		if(!open)
			to_chat(user, span_warning("You need to open \the [src] first."))
			return
		if(ore)
			to_chat(user, span_warning("There's already ore inside [src]."))
			return
		var/obj/item/stack/R = I
		if(!R.use(5))
			to_chat(user, span_warning("You need at least 2 [R]."))
			return
		to_chat(user, span_notice("You throw [R] into [src]."))
		ore = TRUE
		update_appearance()
	else if(I.get_temperature())
		if(open)
			to_chat(user, span_warning("You need to close \the [src] first."))
			return
		if(working)
			to_chat(user, span_warning("\The [src] is already lit."))
			return
		if(!fuel || !ore)
			to_chat(user, span_warning("\The [src] is missing some items to start smelting."))
			return
		to_chat(user, span_notice("You light up [src]."))
		playsound(src, 'dwarfs/sounds/effects/ignite.ogg', 50, TRUE)
		working = TRUE
		particle_source.particles.spawning = 0.5
		START_PROCESSING(SSprocessing, src)
		set_light_on(working)
		update_light()
		update_appearance()
		addtimer(CALLBACK(src, PROC_REF(smelt), user), flux ? smelting_time : smelting_time * 2)
	else
		. = ..()

/obj/structure/blast_furnace/proc/smelt(mob/user)
	user.adjust_experience(/datum/skill/smithing, 16)
	var/obj/ingot = new/obj/item/ingot(get_turf(src))
	ingot.apply_material(/datum/material/pig_iron)
	working = FALSE
	fuel = FALSE
	ore = FALSE
	flux = FALSE
	particle_source.particles.spawning = 0
	set_light_on(working)
	update_light()
	update_appearance()

/obj/structure/blast_furnace/process(delta_time)
	if(!working)
		return PROCESS_KILL
	if(prob(20))
		playsound(src, 'dwarfs/sounds/effects/fire_cracking_short.ogg', 100, TRUE)
