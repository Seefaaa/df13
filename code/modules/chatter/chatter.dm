/proc/chatter(message, atom/A)
	// We want to transform any message into a list of numbers
	// and punctuation marks
	// For example:
	// "Hi." -> [2, '.']
	// "HALP GEROGE MELLONS, that swine, is GRIFFIN ME!"
	// -> [4, 6, 7, ',', 4, 5, ',', '2', 7, 2, '!']
	// "fuck,thissentenceissquashed" -> [4, ',', 21]

	var/mob/living/M = A
	if(M.chatter_cd > world.time)
		return FALSE
	M.chatter_cd = world.time + 2 SECONDS

	var/chatter_timer = world.time + 6 SECONDS

	var/list/punctuation = list(",",":",";",".","?","!","\'","-")
	var/regex/R = regex("(\[\\l\\d]*)(\[^\\l\\d\\s])?", "g")
	var/list/letter_count = list()
	while(R.Find_char(message) != 0)
		if(R.group[1])
			letter_count += length_char(R.group[1])
		if(R.group[2])
			letter_count += R.group[2]

	var/arace = "human"
	var/agender = "male"
	if(iscarbon(A))
		var/mob/living/carbon/human/species/D = A
		switch(D.gender)
			if("female")
				agender = "female"
			else
				agender = "male"
		switch(D.race)
			if(/datum/species/human)
				arace = "human"
			if(/datum/species/goblin)
				arace = "goblin"
			if(/datum/species/dwarf)
				arace = "dwarf"
//			if(/datum/species/elf)
//				arace = "elf"
			else
				arace = "elf"

	spawn(0)
		for(var/item in letter_count)
			if (item in punctuation)
				// simulate pausing in talking
				// ignore semi-colons because of their use in HTML escaping
				if (item in list(",", ":"))
					sleep(3)
				if (item in list("!", "?"))
					sleep(6)
				if (item in list("."))
					chatter_speak_word(A, arace, 1)
					sleep(4)
				continue

			if(isnum(item))
				var/length = min(item, 10)
				chatter_speak_word(A, arace, length, agender)
				sleep(0.5)
				if(chatter_timer < world.time)
					break

/proc/chatter_speak_word(atom/A, arace, length, agender)
	var/path = "sound/runtime/chatter/[arace]_[agender].ogg"
	for(var/c in 1 to length)
		playsound(A.loc, path, 100, rand(32000, 52000), -5, use_reverb = TRUE)
		sleep(chatter_get_sleep_multiplier(arace))

/proc/chatter_get_sleep_multiplier(arace)
	. = 1
	switch(arace)
		if("dwarf")
			. = 1.75
		if("elf")
			. = 1
		if("human")
			. = 1.5
		if("goblin")
			. = 1.5
