///This type is responsible for any map generation behavior that is done in areas, override this to allow for area-specific map generation. This generation is ran by areas in initialize.
/datum/map_generator
	var/area/area

/datum/map_generator/New(my_area=null)
	if(!my_area)
		CRASH("Initialized map_generator datum without an area")
	area = my_area
	. = ..()


///This proc will be ran by areas on Initialize
/datum/map_generator/proc/generate_turfs()
	return

/datum/map_generator/proc/generate_rest()
	return

/datum/map_generator/proc/generate_turf_flora(turf/T)
	return

/datum/map_generator/proc/generate_turf_fauna(turf/T)
	return
