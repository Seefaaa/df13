/particles/smoke
	icon = 'dwarfs/icons/effects/particles.dmi'
	icon_state = list("smoke1", "smoke2")
	width = 500
	height = 500
	count = 20
	spawning = 0
	lifespan = 0.6 SECONDS
	fade = 0.5 SECONDS
	gravity = list(0, 1)
	velocity = generator("box", list(-1, 0.7), list(1, 2))
	drift = generator("box", list(-1, 0), list(1, 0))

/particles/smoke/oven
	position = generator("box", list(-1, 22), list(1, 24))

/particles/smoke/smelter
	position = generator("box", list(-3, 13), list(3, 17))

/particles/smoke/forge
	position = generator("box", list(-6, 32), list(6, 35))
