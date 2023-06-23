/datum/reagent/tanin
	name = "tanin"
	color = "#571d06"

/datum/reagent/tanin/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/item/stack/sheet/dryhide))
		var/obj/item/stack/sheet/dryhide/D = exposed_obj
		new /obj/item/stack/sheet/leather (get_turf(D), D.leather_amount)
		qdel(D)
		holder.remove_reagent(type, 3, 12)
		var/mob/user = exposed_obj.loc
		if(!user || !ismob(user))
			return
		user.adjust_experience(/datum/skill/skinning, rand(2, 8))
