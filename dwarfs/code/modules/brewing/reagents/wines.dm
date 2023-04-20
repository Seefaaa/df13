/datum/reagent/consumable/ethanol/wine
	name = "Wine"
	color = "#c9220cff"

/datum/reagent/consumable/ethanol/wine/New()
	. = ..()
	AddComponent(/datum/component/fermentable, ferment_into=/datum/reagent/consumable/vinegar)

/datum/reagent/consumable/ethanol/wine/plump
	name = "Plump Wine"
	description = "Traditional dwarfen mushroom wine. Heals dwarf's souls and minds (and probably more)."
	color = "#96418aff"

/datum/reagent/consumable/ethanol/wine/rum
	name = "Rum"
	color = "#9D702E"

/datum/reagent/consumable/ethanol/wine/apple
	name = "Apple Cider"
	color = "#C46210"
