///This type is responsible for any map generation behavior that is done in areas, override this to allow for area-specific map generation. This generation is ran by areas in initialize.
/datum/map_generator
	var/area/area
	/// A list that is used in generate_rest proc. We populate it in generate_turfs proc to avoid looping multiple times
	var/list/post_queue = list()
	/// A list of keys used in post_queue. We use it to prevent crashes during generation if it so happens that a key doesn't get populated
	var/list/keys = list()

/datum/map_generator/New(my_area=null)
	if(!my_area)
		CRASH("Initialized map_generator datum without an area")
	area = my_area
	for(var/key in keys)
		post_queue[key] = list()
	. = ..()

/datum/map_generator/proc/queue(key, value)
	if(!(key in post_queue))// this should never happen
		post_queue[key] = list()
	post_queue[key] += list(value)// wrap value in list to avoid adding value's items if it's a list. Otherwise works as intended

/datum/map_generator/proc/prob_queue(chance, key, value)
	if(prob(chance))
		queue(key, value)

///This proc will be ran by areas on Initialize
/datum/map_generator/proc/generate_turfs()
	return

/datum/map_generator/proc/generate_rest()
	return

/datum/map_generator/proc/generate_turf_flora(turf/T)
	return

/datum/map_generator/proc/generate_turf_fauna(turf/T)
	return
