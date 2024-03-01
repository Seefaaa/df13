/datum/reagent/tannin
	name = "tannin"
	color = "#571d06"

/datum/reagent/tannin/expose_obj(obj/exposed_obj, reac_volume)
	. = ..()
	if(istype(exposed_obj, /obj/item/stack/sheet/dryhide))
		var/obj/item/stack/sheet/dryhide/D = exposed_obj
		new /obj/item/stack/sheet/leather (get_turf(holder.my_atom), D.leather_amount)
		qdel(D)
		holder.remove_reagent(type, rand(3, 12))
		var/mob/user = exposed_obj.loc
		if(!user || !ismob(user))
			return
		user.adjust_experience(/datum/skill/skinning, rand(2, 8))
	else if(istype(exposed_obj, /obj/item/stack/sheet/planks))
		if(ispath(exposed_obj.materials, /datum/material/wood/treated))
			return
		var/used_per_item = 4
		var/obj/item/stack/S = exposed_obj
		var/amount_possible = min(round(volume / used_per_item), S.amount)
		if(S.use(amount_possible))
			holder.remove_reagent(type, amount_possible * used_per_item)
			var/obj/item/stack/sheet/planks/P = new(get_turf(holder.my_atom), amount_possible)
			P.apply_material(/datum/material/wood/treated)
			var/mob/user = exposed_obj.loc
			if(!user || !ismob(user))
				return
			user.adjust_experience(/datum/skill/logging, rand(1, 2) * amount_possible)
