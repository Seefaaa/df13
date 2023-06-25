/obj/proc/update_stats(_grade=null, use_grade=TRUE)
	apply_grade(_grade)
	apply_material_stats()

/atom/proc/reset_stats()
	return

/obj/reset_stats()
	. = ..()
	obj_integrity = initial(obj_integrity)
	max_integrity = initial(max_integrity)

/obj/item/reset_stats()
	. = ..()
	slowdown = initial(slowdown)
	melee_cd = initial(melee_cd)

/obj/examine_more(mob/user)
	. = ..()
	var/qualtity_text
	switch(grade)
		if(1)
			qualtity_text = "poorly-crafted"
		if(2)
			qualtity_text = "decently-crafted"
		if(3)
			qualtity_text = "finely-crafted"
		if(4)
			qualtity_text = "superior quality"
		if(5)
			qualtity_text = "exceptional"
		if(6)
			qualtity_text = "Masterful"
	. += "<br>The [src] is [qualtity_text]."
/obj/proc/apply_grade(_grade=null)
	if(_grade)
		src.grade = _grade
	var/grd_name = grade_name(grade)
	name = "[grd_name][initial(name)][grd_name]"
	apply_grade_extra(_grade)

/obj/proc/apply_grade_extra(_grade=null)
	return

/proc/grade_name(grade)
	var/list/grades = list("-", "+", "*", "≡", "☼", "☼☼")
	return grades[grade]

/*******************************************************************************************************************/


/obj/item/zwei/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 20
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=4, blunt=2, fire=0, magic=0)
        if(2)
            force = 27
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=4, blunt=4, fire=0, magic=0)
        if(3)
            force = 33
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=9, pierce=5, blunt=5, fire=0, magic=0)
        if(4)
            force = 38
            throwforce = 30
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=11,pierce=6, blunt=5, fire=0, magic=0)
        if(5)
            force = 42
            throwforce = 36
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=13,pierce=7, blunt=6, fire=0, magic=0)
        if(6)
            force = 45
            throwforce = 40
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=15,pierce=8, blunt=8, fire=0, magic=0)

/obj/item/flail/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 9
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=2, blunt=2, fire=0, magic=0)
        if(2)
            force = 12
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=3, blunt=4, fire=0, magic=0)
        if(3)
            force = 16
            throwforce = 14
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=1, pierce=3, blunt=6, fire=0, magic=0)
        if(4)
            force = 21
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=2, pierce=5, blunt=8, fire=0, magic=0)
        if(5)
            force = 25
            throwforce = 22
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=9, fire=0, magic=0)
        if(6)
            force = 30
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=6, blunt=10,fire=0, magic=0)

/obj/item/dagger/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=5, blunt=0, fire=0, magic=0)
        if(2)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=7, blunt=0, fire=0, magic=0)
        if(3)
            force = 9
            throwforce = 9
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=8, blunt=0, fire=0, magic=0)
        if(4)
            force = 12
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=9, blunt=1, fire=0, magic=0)
        if(5)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=9, pierce=11,blunt=2, fire=0, magic=0)
        if(6)
            force = 18
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=10,pierce=13,blunt=3, fire=0, magic=0)

/obj/item/sword/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 10
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=3, blunt=0, fire=0, magic=0)
        if(2)
            force = 15
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=3, blunt=1, fire=0, magic=0)
        if(3)
            force = 20
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=9, pierce=5, blunt=2, fire=0, magic=0)
        if(4)
            force = 23
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=11,pierce=6, blunt=3, fire=0, magic=0)
        if(5)
            force = 26
            throwforce = 21
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=12,pierce=7, blunt=4, fire=0, magic=0)
        if(6)
            force = 31
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=14,pierce=8, blunt=5, fire=0, magic=0)

/obj/item/spear/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 12
            throwforce = 12
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=2, pierce=7, blunt=2, fire=0, magic=0)
        if(2)
            force = 16
            throwforce = 16
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=7, blunt=2, fire=0, magic=0)
        if(3)
            force = 23
            throwforce = 20
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=9, blunt=3, fire=0, magic=0)
        if(4)
            force = 26
            throwforce = 25
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=11,blunt=5, fire=0, magic=0)
        if(5)
            force = 30
            throwforce = 28
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=13,blunt=6, fire=0, magic=0)
        if(6)
            force = 34
            throwforce = 30
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=8, pierce=14,blunt=7, fire=0, magic=0)

/obj/item/warhammer/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0)
        if(2)
            force = 19
            throwforce = 17
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=1, pierce=2, blunt=7, fire=0, magic=0)
        if(3)
            force = 23
            throwforce = 24
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=2, pierce=3, blunt=9, fire=0, magic=0)
        if(4)
            force = 28
            throwforce = 29
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=11,fire=0, magic=0)
        if(5)
            force = 32
            throwforce = 35
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=5, blunt=12,fire=0, magic=0)
        if(6)
            force = 36
            throwforce = 45
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=4, pierce=6, blunt=13,fire=0, magic=0)

/obj/item/halberd/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 15
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=3, pierce=4, blunt=0, fire=0, magic=0)
        if(2)
            force = 17
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=5, pierce=5, blunt=0, fire=0, magic=0)
        if(3)
            force = 18
            throwforce = 13
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=7, pierce=8, blunt=0, fire=0, magic=0)
        if(4)
            force = 20
            throwforce = 15
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=10,pierce=12,blunt=0, fire=0, magic=0)
        if(5)
            force = 24
            throwforce = 18
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=15,pierce=14,blunt=0, fire=0, magic=0)
        if(6)
            force = 28
            throwforce = 22
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=18,pierce=18,blunt=0, fire=0, magic=0)

/obj/item/scepter/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=1, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=2, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=4, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=5, fire=0, magic=0)
        if(6)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=6, fire=0, magic=0)

/obj/item/pickaxe/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 13
            throwforce = 13
            block_chance = 0
            toolspeed = 0.8
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/axe/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 13
            throwforce = 13
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 15
            throwforce = 15
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 15
            throwforce = 17
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/hoe/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 2
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 7
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 11
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 14
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 16
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/shovel/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 6
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 9
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 12
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 15
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 18
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/chisel/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 1
            throwforce = 1
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 2
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 4
            throwforce = 8
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 5
            throwforce = 10
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 7
            throwforce = 12
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 8
            throwforce = 15
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/builder_hammer/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 2
            throwforce = 2
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 12
            throwforce = 14
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/smithing_hammer/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/tongs/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 3
            throwforce = 3
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/trowel/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 1
            throwforce = 1
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 2
            throwforce = 2
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)

/obj/item/kitchen/knife/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            force = 4
            throwforce = 4
            block_chance = 0
            toolspeed = 3
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(2)
            force = 5
            throwforce = 5
            block_chance = 0
            toolspeed = 2
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(3)
            force = 6
            throwforce = 6
            block_chance = 0
            toolspeed = 1
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(4)
            force = 7
            throwforce = 7
            block_chance = 0
            toolspeed = 0.9
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(5)
            force = 8
            throwforce = 8
            block_chance = 0
            toolspeed = 0.7
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)
        if(6)
            force = 10
            throwforce = 10
            block_chance = 0
            toolspeed = 0.6
            armor_penetration.setRating(sharp=0, pierce=0, blunt=0, fire=0, magic=0)


/*******************************************************************************************************************/

/obj/item/clothing/suit/armor/light_plate/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=6, pierce=2, blunt=0, fire=4, wound=15)
        if(2)
            armor.setRating(sharp=9, pierce=4, blunt=3, fire=5, wound=20)
        if(3)
            armor.setRating(sharp=12,pierce=8, blunt=5, fire=6, wound=25)
        if(4)
            armor.setRating(sharp=16,pierce=10,blunt=7, fire=7, wound=30)
        if(5)
            armor.setRating(sharp=19,pierce=12,blunt=9, fire=8, wound=35)
        if(6)
            armor.setRating(sharp=23,pierce=15,blunt=14,fire=9, wound=40)

/obj/item/clothing/suit/armor/heavy_plate/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=9, pierce=3, blunt=2, fire=6, wound=20)
        if(2)
            armor.setRating(sharp=12,pierce=5, blunt=5, fire=7, wound=25)
        if(3)
            armor.setRating(sharp=15,pierce=9, blunt=8, fire=8, wound=30)
        if(4)
            armor.setRating(sharp=18,pierce=12,blunt=11,fire=9, wound=40)
        if(5)
            armor.setRating(sharp=24,pierce=14,blunt=14,fire=10,wound=45)
        if(6)
            armor.setRating(sharp=30,pierce=17,blunt=18,fire=11,wound=50)

/obj/item/clothing/under/chainmail/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=5, pierce=0, blunt=2, fire=5, wound=10)
        if(2)
            armor.setRating(sharp=8, pierce=3, blunt=5, fire=6, wound=15)
        if(3)
            armor.setRating(sharp=11,pierce=6, blunt=7, fire=7, wound=20)
        if(4)
            armor.setRating(sharp=14,pierce=9, blunt=10,fire=8, wound=25)
        if(5)
            armor.setRating(sharp=17,pierce=12,blunt=12,fire=9, wound=30)
        if(6)
            armor.setRating(sharp=20,pierce=14,blunt=15,fire=10,wound=35)

/obj/item/clothing/head/helmet/plate_helmet/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=5, pierce=3, blunt=2, fire=5, wound=15)
        if(2)
            armor.setRating(sharp=9, pierce=5, blunt=4, fire=6, wound=20)
        if(3)
            armor.setRating(sharp=13,pierce=8, blunt=7, fire=7, wound=25)
        if(4)
            armor.setRating(sharp=17,pierce=11,blunt=9, fire=8, wound=30)
        if(5)
            armor.setRating(sharp=20,pierce=13,blunt=12,fire=9, wound=35)
        if(6)
            armor.setRating(sharp=23,pierce=16,blunt=15,fire=10,wound=40)

/obj/item/clothing/gloves/plate_gloves/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=5, pierce=3, blunt=2, fire=5, wound=15)
        if(2)
            armor.setRating(sharp=9, pierce=5, blunt=4, fire=6, wound=20)
        if(3)
            armor.setRating(sharp=13,pierce=8, blunt=7, fire=7, wound=25)
        if(4)
            armor.setRating(sharp=17,pierce=11,blunt=9, fire=8, wound=30)
        if(5)
            armor.setRating(sharp=20,pierce=13,blunt=12,fire=9, wound=35)
        if(6)
            armor.setRating(sharp=23,pierce=16,blunt=15,fire=10,wound=40)

/obj/item/clothing/shoes/jackboots/plate_boots/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=5, pierce=3, blunt=2, fire=5, wound=15)
        if(2)
            armor.setRating(sharp=9, pierce=5, blunt=4, fire=6, wound=20)
        if(3)
            armor.setRating(sharp=13,pierce=8, blunt=7, fire=7, wound=25)
        if(4)
            armor.setRating(sharp=17,pierce=11,blunt=9, fire=8, wound=30)
        if(5)
            armor.setRating(sharp=20,pierce=13,blunt=12,fire=9, wound=35)
        if(6)
            armor.setRating(sharp=23,pierce=16,blunt=15,fire=10,wound=40)

/obj/item/clothing/head/helmet/crown/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=2, pierce=0, blunt=0, fire=5, wound=0)
        if(2)
            armor.setRating(sharp=4, pierce=0, blunt=0, fire=0, wound=0)
        if(3)
            armor.setRating(sharp=6, pierce=0, blunt=0, fire=0, wound=0)
        if(4)
            armor.setRating(sharp=8, pierce=0, blunt=0, fire=0, wound=0)
        if(5)
            armor.setRating(sharp=9, pierce=0, blunt=0, fire=0, wound=0)
        if(6)
            armor.setRating(sharp=10,pierce=0, blunt=0, fire=0, wound=0)

/obj/item/clothing/shoes/boots/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=1, pierce=0, blunt=0, fire=5, wound=0)
        if(2)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(3)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(4)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(5)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(6)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)

/obj/item/clothing/under/tunic/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=1, pierce=0, blunt=0, fire=5, wound=0)
        if(2)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(3)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(4)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(5)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)
        if(6)
            armor.setRating(sharp=0, pierce=0, blunt=0, fire=0, wound=0)

/obj/item/clothing/head/helmet/light_helmet/apply_grade(grade)
    ..()
    switch(grade)
        if(1)
            armor.setRating(sharp=3, pierce=2, blunt=2, fire=4, wound=10)
        if(2)
            armor.setRating(sharp=5, pierce=4, blunt=3, fire=5, wound=15)
        if(3)
            armor.setRating(sharp=8, pierce=7, blunt=5, fire=6, wound=20)
        if(4)
            armor.setRating(sharp=11,pierce=9, blunt=7, fire=7, wound=25)
        if(5)
            armor.setRating(sharp=14,pierce=12,blunt=9, fire=8, wound=30)
        if(6)
            armor.setRating(sharp=18,pierce=14,blunt=12,fire=9, wound=35)

