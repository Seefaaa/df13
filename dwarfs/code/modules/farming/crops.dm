/// plants that are collected once only
/obj/structure/plant/garden/crop
	name = "crop"
	lifespan = 6

/obj/structure/plant/garden/crop/grown()
	. = ..()
	harvestable = TRUE

/obj/structure/plant/garden/crop/Initialize()
	. = ..()
	icon_ripe = "[species]-[growthstages]"

/obj/structure/plant/garden/crop/harvest(mob/user)
	. = ..()
	if(!.)
		return
	qdel(src)

/obj/structure/plant/garden/crop/plump_helmet
	name = "plump helmet"
	desc = "Some dwarves like plump helmets for their rounded tops."
	species = "plump_helmet"
	health = 30
	maxhealth = 30
	growthdelta = 90 SECONDS
	produce_delta = 40 SECONDS
	produced = list(/obj/item/growable/plump_helmet=3)
	seed_type = /obj/item/growable/seeds/plump_helmet
	surface = FALSE

/obj/structure/plant/garden/crop/pig_tail
	name = "pig tail"
	desc = "Twisting stalk which can be made into thread."
	species = "pig_tail"
	health = 50
	maxhealth = 50
	growthdelta = 90 SECONDS
	produce_delta = 80 SECONDS
	produced = list(/obj/item/growable/pig_tail=2)
	seed_type = /obj/item/growable/seeds/pig_tail
	surface = FALSE

/obj/structure/plant/garden/crop/barley
	name = "barley"
	desc = "One of the most common grains you can find in human settlements."
	species = "barley"
	health = 40
	maxhealth = 40
	growthdelta = 70 SECONDS
	produce_delta = 60 SECONDS
	produced = list(/obj/item/growable/barley=4)
	seed_type = /obj/item/growable/seeds/barley

/obj/structure/plant/garden/crop/cotton
	name = "cotton"
	desc = "Its smooth buds is useful for a thread processing."
	species = "cotton"
	health = 50
	maxhealth = 50
	growthdelta = 120 SECONDS
	produce_delta = 80 SECONDS
	produced = list(/obj/item/growable/cotton=2)
	seed_type = /obj/item/growable/seeds/cotton

/obj/structure/plant/garden/crop/turnip
	name = "turnip"
	desc = "White root known for its sweet taste."
	species = "turnip"
	health = 45
	maxhealth = 45
	growthdelta = 100 SECONDS
	produce_delta = 45 SECONDS
	produced = list(/obj/item/growable/turnip=2)
	seed_type = /obj/item/growable/seeds/turnip

/obj/structure/plant/garden/crop/carrot
	name = "carrot"
	desc = "White flowering plant with orange edible root."
	species = "carrot"
	health = 45
	maxhealth = 45
	growthdelta = 100 SECONDS
	produce_delta = 45 SECONDS
	produced = list(/obj/item/growable/carrot=2)
	seed_type = /obj/item/growable/seeds/carrot

/obj/structure/plant/garden/crop/cave_wheat
	name = "cave wheat"
	desc = "Grain adapted to lack of sunlight and harsh soils of underground dwarven farms."
	species = "cave_wheat"
	health = 40
	maxhealth = 40
	growthdelta = 90 SECONDS
	produce_delta = 60 SECONDS
	produced = list(/obj/item/growable/cave_wheat=4)
	seed_type = /obj/item/growable/seeds/cave_wheat
	surface = FALSE

/obj/structure/plant/garden/crop/potato
	name = "potato"
	desc = "A popular food due to its versatilily and adapatability to many growing conditions."
	species = "potato"
	health = 50
	maxhealth = 50
	growthdelta = 80 SECONDS
	produce_delta = 60 SECONDS
	produced = list(/obj/item/growable/potato=3)
	seed_type = /obj/item/growable/seeds/potato

/obj/structure/plant/garden/crop/onion
	name = "onion"
	desc = "Often mistaken for a weed."
	species = "onion"
	health = 30
	maxhealth = 30
	growthdelta = 1 MINUTES
	produced = list(/obj/item/growable/onion=3)
	seed_type = /obj/item/growable/seeds/onion
