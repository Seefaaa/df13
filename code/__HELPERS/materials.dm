/proc/get_part_name(part)
	switch(part)
		if(PART_ANY)
			return "anything"
		if(PART_HANDLE)
			return "handle"
		if(PART_HEAD)
			return "tool head"
		if(PART_INGOT)
			return "ingot"
		if(PART_PLANKS)
			return "any planks"
		if(PART_STONE)
			return "any stone"
		else
			return "unidentified part"

/proc/get_default_part(part)
	switch(part)
		if(PART_HANDLE)
			return /obj/item/stick
		if(PART_HEAD)
			return /obj/item/partial/axe
		if(PART_INGOT)
			return /obj/item/ingot
		if(PART_PLANKS)
			return /obj/item/stack/sheet/planks
		if(PART_STONE)
			return /obj/item/stack/sheet/stone
		else
			return /obj/item/stack/sheet/stone
