/proc/chatter(message, phomeme, atom/A)
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

	if(iscarbon(A))
		var/mob/living/carbon/D = A
		switch(D.gender)
			if("male")
				phomeme = "owl"
			else
				phomeme = "griffin"

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
					chatter_speak_word(A, phomeme, 1)
					sleep(4)
				continue

			if(isnum(item))
				var/length = min(item, 10)
				chatter_speak_word(A, phomeme, length)
				sleep(0.5)
				if(chatter_timer < world.time)
					break

/proc/chatter_speak_word(atom/A, phomeme, length)
	var/path = "sound/runtime/chatter/[phomeme]_1.ogg"
	for(var/c in 1 to length)
		playsound(A.loc, path, 25, rand(20000, 25000), -5, SOUND_DEFAULT_FALLOFF_DISTANCE)
		sleep(2 * chatter_get_sleep_multiplier(phomeme))

/proc/chatter_get_sleep_multiplier(phomeme)
	// These values are tenths of seconds, so 0.5 == 0.05seconds
	. = 1
	switch(phomeme)
		if("papyrus")
			. = 0.5
		if("griffin")
			. = 0.5
		if("sans")
			. = 0.7
		if("owl")
			. = 0.7
