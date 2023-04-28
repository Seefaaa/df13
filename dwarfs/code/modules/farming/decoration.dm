/obj/structure/plant/decor
	growthstages = 1
	lifespan = INFINITY
	dummy = TRUE
	obj_integrity = 5
	max_integrity = 5
	icon = 'dwarfs/icons/farming/decoration.dmi'
	spread_x = 8
	spread_y = 10

/obj/structure/plant/decor/flower
	name = "flower"
	desc = "It smells nice."

/obj/structure/plant/decor/flower/Initialize()
	. = ..()
	icon_state = "flower[rand(1, 6)]"
