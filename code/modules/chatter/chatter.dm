/proc/chatter(message, atom/A)
	// Transform any message into a list of numbers and punctuation marks
	// "HALP GEROGE MELLONS, that swine, is GRIFFIN ME!" -> [4, 6, 7, ',', 4, 5, ',', '2', 7, 2, '!']
	// "hell,thissentenceissquashed" -> [4, ',', 21]

	var/mob/living/carbon/human/D = A
	if(!isliving(A)) /// Runtime protections, since everything that talks is /mob/living
		return FALSE
	if(D.chatter_cd > world.time)
		return FALSE

	D.chatter_cd = world.time + 2 SECONDS

	var/chatter_timer = world.time + 6 SECONDS
	var/chatter_vol = D.client?.prefs.chatter_volume || 100

	var/agender = D.gender == "female" ? "female" : "male" /// Default is Male
	var/arace = D.dna.species.id || "elf" /// Default is elf, but its mostly for simplemobs or undetified carbons

	var/list/punctuation = list(",",":",";",".","?","!","\'","-")
	var/regex/R = regex("(\[\\l\\d]*)(\[^\\l\\d\\s])?", "g")
	var/list/letter_count = list()
	while(R.Find_char(message) != 0)
		if(R.group[1])
			letter_count += length_char(R.group[1])
		if(R.group[2])
			letter_count += R.group[2]

	spawn(0)
		for(var/item in letter_count)
			if (item in punctuation)
				// simulate pausing in talking; ignore semi-colons because of their use in HTML escaping
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
				chatter_speak_word(A, arace, length, agender, chatter_vol)
				sleep(0.5)
				if(chatter_timer < world.time) // Avoiding infinite chatter spam
					break

/proc/chatter_speak_word(atom/A, arace, length, agender, chatter_vol)
	var/path = "sound/runtime/chatter/[arace]_[agender].ogg"
	for(var/c in 1 to length)
		playsound(A.loc, path, chatter_vol, rand(32000, 52000), -3, use_reverb = TRUE)
		sleep(chatter_get_sleep_multiplier(arace))

/proc/chatter_get_sleep_multiplier(arace)
	switch(arace)
		if("dwarf")
			return 1.75
		if("elf")
			return 1.25
		if("human")
			return 1.5
		if("goblin")
			return 1.5
		else
			return 1.25
