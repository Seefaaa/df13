#define MAX_GOATS_RANGE 15
#define MAX_GOATS_NEARBY 10

/mob/living/simple_animal/goat
	name = "goat"
	desc = "Common cattle used for their variety of produce."
	icon = 'dwarfs/icons/mob/animals.dmi'
	icon_state = "goat_brown_m"
	maxHealth = 50
	health = 50
	childtype = list(/mob/living/simple_animal/goat/baby)
	animal_species = /mob/living/simple_animal/goat
	// Used for icon state: see ./Initialize
	var/color_txt = "brown"
	// Does it have a bag mounted
	var/bag = FALSE
	// UNUSED yet
	var/lantern = FALSE
	// Did it eat?
	var/fed = FALSE

/mob/living/simple_animal/goat/Initialize(mapload, _gender=null, _color=null)
	. = ..()
	gender = _gender ? _gender : pick(MALE, FEMALE)
	color_txt = _color ? _color : pick("brown", "grey")
	icon_dead = "goat_[color_txt]_[gender == MALE ? "m" : "f"]_dead"
	icon_state = "goat_[color_txt]_[gender == MALE ? "m" : "f"]"

/mob/living/simple_animal/goat/death(gibbed)
	. = ..()
	if(bag)
		bag = FALSE // in case somehow it gets revived
		var/obj/item/I = contents[1]
		I.forceMove(get_turf(src))

/mob/living/simple_animal/goat/update_overlays()
	. = ..()
	if(bag)
		. += mutable_appearance(icon, "goat_bag_[gender == MALE ? "m" : "f"]")

/mob/living/simple_animal/goat/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/storage/goat))
		if(isstrictlytype(src, /mob/living/simple_animal/goat/baby))
			to_chat(user, span_warning("Cannot mount a bag on [src]!"))
			return
		if(bag)
			to_chat(user, span_warning("[src] already has a bag mounted!"))
			return
		to_chat(user, span_notice("You mount [I] onto [src]."))
		I.forceMove(src)
		bag = TRUE
		update_appearance()
	if(isgrowable(I))
		var/obj/item/growable/G = I
		if(G.food_flags & GRAIN)
			to_chat(user, span_notice("You feed [src] [G]."))
			playsound(loc, 'sound/items/eatfood.ogg', rand(10,50), TRUE)
			qdel(G)
			fed = TRUE
	else
		. = ..()

/mob/living/simple_animal/goat/attack_hand(mob/living/carbon/human/M)
	if(bag && M.a_intent == INTENT_HELP)
		var/obj/item/I = contents[1]
		var/datum/component/storage/S = I.GetComponent(/datum/component/storage/concrete)
		S.show_to(M)
	else
		. = ..()

/mob/living/simple_animal/goat/m
/mob/living/simple_animal/goat/m/Initialize(mapload, _gender, _color)
	. = ..(mapload, MALE)
/mob/living/simple_animal/goat/f
/mob/living/simple_animal/goat/f/Initialize(mapload, _gender, _color)
	. = ..(mapload, FEMALE)


/mob/living/simple_animal/goat/baby
	name = "baby goat"
	icon_state = "goat_brown_baby"

/mob/living/simple_animal/goat/baby/Initialize(mapload)
	. = ..()
	icon_state = "goat_[color_txt]_baby"
	icon_dead = "goat_[color_txt]_baby_dead"
	addtimer(CALLBACK(src, .proc/grow_up), 4 MINUTES)

/mob/living/simple_animal/goat/baby/proc/grow_up()
	if(!src)
		return
	new /mob/living/simple_animal/goat(get_turf(src), gender, color_txt)
	qdel(src)


/mob/living/simple_animal/goat/make_babies()
	if(!fed)
		return

	var/count = 0
	for(var/mob/living/simple_animal/goat in range(MAX_GOATS_RANGE, src))
		if(count > MAX_GOATS_NEARBY)
			return
		count++
	fed = FALSE
	. = ..()

/mob/living/simple_animal/goat/Life(delta_time, times_fired)
	..()
	make_babies()

#undef MAX_GOATS_NEARBY
#undef MAX_GOATS_RANGE

// TODO: add milking
