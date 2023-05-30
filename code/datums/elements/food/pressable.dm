/datum/component/pressable
	///What we get after pressing something under a press
	var/datum/reagent/liquid_result = null
	///How much of this liquid do we get?
	var/liquid_amount = 0
	///What atom do we get after pressing
	var/atom_result = null
	///How much of that do we get
	var/atom_amount = 0

/datum/component/pressable/Initialize(liquid_result=null, liquid_amount=10, atom_result=null, atom_amount=1)

	src.liquid_result = liquid_result
	src.liquid_amount = liquid_amount
	src.atom_result = atom_result
	src.atom_amount = atom_amount

	RegisterSignal(parent, COSMIG_ITEM_SQUEEZED, .proc/squeeze)

/datum/component/pressable/proc/squeeze(obj/item/growable/G, obj/structure/press/P, amt_types = 1)
	SIGNAL_HANDLER
	if(liquid_result)
		if(amt_types <= 1)
			P.reagents.add_reagent(liquid_result, liquid_amount)
		else
			P.reagents.add_reagent(/datum/reagent/blood, liquid_amount)
	if(atom_result)
		var/turf/T = get_turf(P)
		for(var/i in 1 to atom_amount)
			var/atom/movable/A = new atom_result(T)
			A.forceMove()
	if(isitem(parent))
		qdel(parent)
	else//reagent
		var/datum/reagent/R = parent
		P.reagents.remove_reagent(R.type, R.volume)
