SUBSYSTEM_DEF(title)
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/file_path
	var/icon/icon
	var/turf/closed/indestructible/splashscreen/splash_turf

/datum/controller/subsystem/title/Initialize()
	if(file_path && icon)
		return ..()

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/title_screens = list()

	for(var/S in provisional_title_screens)
		var/list/L = splittext(S,"+")
		if(L.len == 1 && (L[1] != "exclude" && L[1] != "blank.png"))
			title_screens += S

	if(length(title_screens))
		file_path = "[global.config.directory]/title_screens/images/[pick(title_screens)]"

	if(!file_path)
		file_path = "icons/runtime/default_title.dmi"

	ASSERT(fexists(file_path))

	icon = new(fcopy_rsc(file_path))

	splash_turf = locate(/turf/closed/indestructible/splashscreen)

	if(splash_turf)
		splash_turf.icon = icon
	else
		CRASH("Splash turf is not initialized!")

	return ..()

/datum/controller/subsystem/title/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if(NAMEOF(src, icon))
				if(splash_turf)
					splash_turf.icon = icon

/datum/controller/subsystem/title/Shutdown()
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/atom/movable/screen/splash/S = new(thing, FALSE)
		S.Fade(FALSE,FALSE)

/datum/controller/subsystem/title/Recover()
	icon = SStitle.icon
	splash_turf = SStitle.splash_turf
	file_path = SStitle.file_path
