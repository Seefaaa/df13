/obj/structure/plant/decor
	growthstages = 1
	lifespan = INFINITY
	dummy = TRUE
	icon = 'dwarfs/icons/farming/decoration.dmi'

/obj/structure/plant/decor/flower
	name = "flower"
	desc = "It smells nice."

/obj/structure/plant/decor/flower/Initialize()
	. = ..()
	icon_state = "flower[rand(1, 6)]"
