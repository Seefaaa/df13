/datum/component/grindable
	///What we get after grinding something in a quern
	var/datum/reagent/grindable_liquid_type
	///How much of this liquid do we get?
	var/liquid_amount
	///If we convert grains to flour
	var/liquid_ratio = 1
	///How much of the resulting item we get
	var/item_amount = 1
	///What type of item we get
	var/item_type

/datum/component/grindable/Initialize(grindable_liquid_type=null, liquid_amount=10, liquid_ratio=1, item_type=null, item_amount=1)
	if(!grindable_liquid_type && !item_type)
		stack_trace("Grindable component added without any resulting reagent or item.")
		return COMPONENT_INCOMPATIBLE

	src.grindable_liquid_type = grindable_liquid_type
	src.liquid_amount = liquid_amount
	src.liquid_ratio = liquid_ratio
	src.item_type = item_type
	src.item_amount = item_amount

	RegisterSignal(parent, COSMIG_ITEM_GRINDED, PROC_REF(grind_item))
	RegisterSignal(parent, COSMIG_REAGENT_GRINDED, PROC_REF(grind_reagent))

/datum/component/grindable/proc/grind_item(obj/item/growable/source, obj/structure/quern/Q)
	SIGNAL_HANDLER
	if(grindable_liquid_type)
		Q.reagents.add_reagent(grindable_liquid_type, liquid_amount)
	if(item_type)
		for(var/i in 1 to item_amount)
			new item_type(get_turf(Q))
	qdel(parent)

/datum/component/grindable/proc/grind_reagent(datum/reagent/source, obj/structure/quern/Q)
	SIGNAL_HANDLER
	var/vol = liquid_amount
	if(source.volume < liquid_amount)
		vol = source.volume
	Q.reagents.remove_reagent(source.type, vol)
	if(grindable_liquid_type)
		Q.reagents.add_reagent(grindable_liquid_type, vol*liquid_ratio)
	if(item_type)
		for(var/i in 1 to item_amount)
			new item_type(get_turf(Q))
