/proc/getArmorPen(sharp = 0, pierce = 0, blunt = 0, fire = 0, acid = 0, magic = 0)
	return new /datum/armor_penetration(sharp, pierce, blunt, fire, acid, magic)


/datum/armor_penetration
	var/sharp
	var/pierce
	var/blunt
	var/fire
	var/acid
	var/magic

/datum/armor_penetration/New(sharp = 0, pierce = 0, blunt = 0, fire = 0, acid = 0, magic = 0)
	src.sharp = sharp
	src.pierce = pierce
	src.blunt = blunt
	src.fire = fire
	src.acid = acid
	src.magic = magic

/datum/armor_penetration/proc/setRating(sharp, pierce, blunt, fire, acid, magic)
	src.sharp = isnull(sharp) ? src.sharp : sharp
	src.pierce = isnull(pierce) ? src.pierce : pierce
	src.blunt = isnull(blunt) ? src.blunt : blunt
	src.fire = isnull(fire) ? src.fire : fire
	src.acid = isnull(acid) ? src.acid : acid
	src.magic = isnull(magic) ? src.magic : magic

/datum/armor_penetration/proc/GetRating(rating)
	return vars[rating]

/datum/armor_penetration/proc/modify_rating(rating, mod, max_rating=90)
	vars[rating] = min(vars[rating] * mod, max_rating)
