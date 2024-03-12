/**
 * # Outfit datums
 *
 * This is a clean system of applying outfits to mobs, if you need to equip someone in a uniform
 * this is the way to do it cleanly and properly.
 *
 * You can also specify an outfit datum on a job to have it auto equipped to the mob on join
 *
 * /mob/living/carbon/human/proc/equipOutfit(outfit) is the mob level proc to equip an outfit
 * and you pass it the relevant datum outfit
 *
 * outfits can also be saved as json blobs downloadable by a client and then can be uploaded
 * by that user to recreate the outfit, this is used by admins to allow for custom event outfits
 * that can be restored at a later date
 */
/datum/outfit
	///Name of the outfit (shows up in the equip admin verb)
	var/name = "Naked"

	/// Type path of item to go in uniform slot
	var/uniform = null
	var/uniform_grade = 0
	var/uniform_materials = null

	/// Type path of item to go in suit slot
	var/suit = null
	var/suit_grade = 0
	var/suit_materials = null

	/// Type path of item to go in back slot
	var/back = null
	var/back_grade = 0
	var/back_materials = null

	/// Type path of item to go in belt slot
	var/belt = null
	var/belt_grade = 0
	var/belt_materials = null

	/// Type path of item to go in gloves slot
	var/gloves = null
	var/gloves_grade = 0
	var/gloves_materials = null

	/// Type path of item to go in shoes slot
	var/shoes = null
	var/shoes_grade = 0
	var/shoes_materials = null

	/// Type path of item to go in head slot
	var/head = null
	var/head_grade = 0
	var/head_materials = null

	/// Type path of item to go in mask slot
	var/mask = null
	var/mask_grade = 0
	var/mask_materials = null

	/// Type path of item to go in neck slot
	var/neck = null
	var/neck_grade = 0
	var/neck_materials = null

	/// Type path of item to go in ears slot
	var/ears = null
	var/ears_grade = 0
	var/ears_materials = null

	/// Type path of item to go in the glasses slot
	var/glasses = null
	var/glasses_grade = 0
	var/glasses_materials = null

	/// Type path of item for left pocket slot
	var/l_pocket = null
	var/l_pocket_grade = 0
	var/l_pocket_materials = null

	/// Type path of item for right pocket slot
	var/r_pocket = null
	var/r_pocket_grade = 0
	var/r_pocket_materials = null

	/**
	  * Type path of item to go in suit storage slot
	  *
	  * (make sure it's valid for that suit)
	  */
	var/suit_store = null
	var/suit_store_grade = 0
	var/suit_store_materials = null

	///Type path of item to go in the right hand
	var/r_hand = null
	var/r_hand_grade = 0
	var/r_hand_materials = null

	//Type path of item to go in left hand
	var/l_hand = null
	var/l_hand_grade = 0
	var/l_hand_materials = null

	/// Should the toggle helmet proc be called on the helmet during equip
	var/toggle_helmet = TRUE

	///ID of the slot containing a gas tank
	var/internals_slot = null

	/**
	  * list of items that should go in the backpack of the user
	  *
	  * Format of this list should be: list(path=count,otherpath=count)
	  */
	var/list/backpack_contents = null

	/// Internals box. Will be inserted at the start of backpack_contents
	var/box

	/**
	  * Any implants the mob should start implanted with
	  *
	  * Format of this list is (typepath, typepath, typepath)
	  */
	var/list/implants = null

	/**
	  * Any skillchips the mob should have in their brain.
	  *
	  * Format of this list is (typepath, typepath, typepath)
	  */
	var/list/skillchips = null

	/// List of skills to apply. Format: (typepath1=lvl1, typepath2=lvl2)
	var/list/skills = null

	/// Any undershirt. While on humans it is a string, here we use paths to stay consistent with the rest of the equips.
	var/datum/sprite_accessory/undershirt = null

	/// Any clothing accessory item
	var/accessory = null

	/// Set to FALSE if your outfit requires runtime parameters
	var/can_be_admin_equipped = TRUE

	/**
	  * extra types for chameleon outfit changes, mostly guns
	  *
	  * Format of this list is (typepath, typepath, typepath)
	  *
	  * These are all added and returns in the list for get_chamelon_diguise_info proc
	  */
	var/list/chameleon_extras

/**
 * Called at the start of the equip proc
 *
 * Override to change the value of the slots depending on client prefs, species and
 * other such sources of change
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/pre_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overridden for customization depending on client prefs,species etc
	return

/**
 * Called after the equip proc has finished
 *
 * All items are on the mob at this point, use this proc to toggle internals
 * fiddle with id bindings and accesses etc
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	//to be overridden for toggling internals, id binding, access etc
	return

/**
 * Equips all defined types and paths to the mob passed in
 *
 * Extra Arguments
 * * visualsOnly true if this is only for display (in the character setup screen)
 *
 * If visualsOnly is true, you can omit any work that doesn't visually appear on the character sprite
 */
/datum/outfit/proc/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	pre_equip(H, visualsOnly)

	if(skills)
		for(var/skilltype in skills)
			var/lvl = skills[skilltype]
			H.adjust_experience(skilltype, SKILL_EXP_LIST[lvl], TRUE)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		var/obj/item/I = new uniform(H)
		if(uniform_materials)
			I.apply_material(uniform_materials)
		if(uniform_grade)
			I.update_stats(uniform_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_ICLOTHING, TRUE)
	if(suit)
		var/obj/item/I = new suit(H)
		if(suit_materials)
			I.apply_material(suit_materials)
		if(suit_grade)
			I.update_stats(suit_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_OCLOTHING, TRUE)
	if(back)
		var/obj/item/I = new back(H)
		if(back_materials)
			I.apply_material(back_materials)
		if(back_grade)
			I.update_stats(back_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_BACK, TRUE)
	if(belt)
		var/obj/item/I = new belt(H)
		if(belt_materials)
			I.apply_material(belt_materials)
		if(belt_grade)
			I.update_stats(belt_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_BELT, TRUE)
	if(gloves)
		var/obj/item/I = new gloves(H)
		if(gloves_materials)
			I.apply_material(gloves_materials)
		if(gloves_grade)
			I.update_stats(gloves_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_GLOVES, TRUE)
	if(shoes)
		var/obj/item/I = new shoes(H)
		if(shoes_materials)
			I.apply_material(shoes_materials)
		if(shoes_grade)
			I.update_stats(shoes_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_FEET, TRUE)
	if(head)
		var/obj/item/I = new head(H)
		if(head_materials)
			I.apply_material(head_materials)
		if(head_grade)
			I.update_stats(head_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_HEAD, TRUE)
	if(mask)
		var/obj/item/I = new mask(H)
		if(mask_materials)
			I.apply_material(mask_materials)
		if(mask_grade)
			I.update_stats(mask_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_MASK, TRUE)
	if(neck)
		var/obj/item/I = new neck(H)
		if(neck_materials)
			I.apply_material(neck_materials)
		if(neck_grade)
			I.update_stats(neck_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_NECK, TRUE)
	if(ears)
		var/obj/item/I = new ears(H)
		if(ears_materials)
			I.apply_material(ears_materials)
		if(ears_grade)
			I.update_stats(ears_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_EARS, TRUE)
	if(glasses)
		var/obj/item/I = new glasses(H)
		if(glasses_materials)
			I.apply_material(glasses_materials)
		if(glasses_grade)
			I.update_stats(glasses_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_EYES, TRUE)
	if(suit_store)
		var/obj/item/I = new suit_store(H)
		if(suit_store_materials)
			I.apply_material(suit_store_materials)
		if(suit_store_grade)
			I.update_stats(suit_store_grade)
		H.equip_to_slot_or_del(I,ITEM_SLOT_SUITSTORE, TRUE)

	if(undershirt)
		H.undershirt = initial(undershirt.name)

	if(accessory)
		var/obj/item/clothing/under/U = H.w_uniform
		if(U)
			U.attach_accessory(new accessory(H))
		else
			WARNING("Unable to equip accessory [accessory] in outfit [name]. No uniform present!")

	if(l_hand)
		var/obj/item/I = new l_hand(H)
		if(l_hand_materials)
			I.apply_material(l_hand_materials)
		if(l_hand_grade)
			I.update_stats(l_hand_grade)
		H.put_in_l_hand(I)
	if(r_hand)
		var/obj/item/I = new r_hand(H)
		if(r_hand_materials)
			I.apply_material(r_hand_materials)
		if(r_hand_grade)
			I.update_stats(r_hand_grade)
		H.put_in_r_hand(I)

	if(!visualsOnly) // Items in pockets or backpack don't show up on mob's icon.
		if(l_pocket)
			var/obj/item/I = new l_pocket(H)
			if(l_pocket_materials)
				I.apply_material(l_pocket_materials)
			if(l_pocket_grade)
				I.update_stats(l_pocket_grade)
			H.equip_to_slot_or_del(I,ITEM_SLOT_LPOCKET, TRUE)
		if(r_pocket)
			var/obj/item/I = new r_pocket(H)
			if(r_pocket_materials)
				I.apply_material(r_pocket_materials)
			if(r_pocket_grade)
				I.update_stats(r_pocket_grade)
			H.equip_to_slot_or_del(I,ITEM_SLOT_RPOCKET, TRUE)

		if(box)
			if(!backpack_contents)
				backpack_contents = list()
			backpack_contents.Insert(1, box)
			backpack_contents[box] = 1

		if(backpack_contents)
			for(var/path in backpack_contents)
				var/number = backpack_contents[path]
				if(!isnum(number))//Default to 1
					number = 1
				for(var/i in 1 to number)
					var/obj/item/I = new path(H)
					H.equip_to_slot_or_del(I,ITEM_SLOT_BACKPACK, TRUE)

	post_equip(H, visualsOnly)

	if(!visualsOnly)
		apply_fingerprints(H)

	H.update_body()
	return TRUE

/**
 * Apply a fingerprint from the passed in human to all items in the outfit
 *
 * Used for forensics setup when the mob is first equipped at roundstart
 * essentially calls add_fingerprint to every defined item on the human
 *
 */
/datum/outfit/proc/apply_fingerprints(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(H.back)
		H.back.add_fingerprint(H, ignoregloves = TRUE)
		for(var/obj/item/I in H.back.contents)
			I.add_fingerprint(H, ignoregloves = TRUE)
	if(H.w_uniform)
		H.w_uniform.add_fingerprint(H, ignoregloves = TRUE)
	if(H.wear_suit)
		H.wear_suit.add_fingerprint(H, ignoregloves = TRUE)
	if(H.wear_mask)
		H.wear_mask.add_fingerprint(H, ignoregloves = TRUE)
	if(H.wear_neck)
		H.wear_neck.add_fingerprint(H, ignoregloves = TRUE)
	if(H.head)
		H.head.add_fingerprint(H, ignoregloves = TRUE)
	if(H.shoes)
		H.shoes.add_fingerprint(H, ignoregloves = TRUE)
	if(H.gloves)
		H.gloves.add_fingerprint(H, ignoregloves = TRUE)
	if(H.ears)
		H.ears.add_fingerprint(H, ignoregloves = TRUE)
	if(H.glasses)
		H.glasses.add_fingerprint(H, ignoregloves = TRUE)
	if(H.belt)
		H.belt.add_fingerprint(H, ignoregloves = TRUE)
		for(var/obj/item/I in H.belt.contents)
			I.add_fingerprint(H, ignoregloves = TRUE)
	if(H.s_store)
		H.s_store.add_fingerprint(H, ignoregloves = TRUE)
	if(H.l_store)
		H.l_store.add_fingerprint(H, ignoregloves = TRUE)
	if(H.r_store)
		H.r_store.add_fingerprint(H, ignoregloves = TRUE)
	for(var/obj/item/I in H.held_items)
		I.add_fingerprint(H, ignoregloves = TRUE)
	return TRUE

/// Return a list of all the types that are required to disguise as this outfit type
/datum/outfit/proc/get_chameleon_disguise_info()
	var/list/types = list(uniform, suit, back, belt, gloves, shoes, head, mask, neck, ears, glasses, l_pocket, r_pocket, suit_store, r_hand, l_hand)
	types += chameleon_extras
	types += skillchips
	list_clear_nulls(types)
	return types

/// Return a json list of this outfit
/datum/outfit/proc/get_json_data()
	. = list()
	.["outfit_type"] = type
	.["name"] = name
	.["uniform"] = uniform
	.["suit"] = suit
	.["toggle_helmet"] = toggle_helmet
	.["back"] = back
	.["belt"] = belt
	.["gloves"] = gloves
	.["shoes"] = shoes
	.["head"] = head
	.["mask"] = mask
	.["neck"] = neck
	.["ears"] = ears
	.["glasses"] = glasses
	.["l_pocket"] = l_pocket
	.["r_pocket"] = r_pocket
	.["suit_store"] = suit_store
	.["r_hand"] = r_hand
	.["l_hand"] = l_hand
	.["internals_slot"] = internals_slot
	.["backpack_contents"] = backpack_contents
	.["box"] = box
	.["implants"] = implants
	.["accessory"] = accessory

/// Prompt the passed in mob client to download this outfit as a json blob
/datum/outfit/proc/save_to_file(mob/admin)
	var/stored_data = get_json_data()
	var/json = json_encode(stored_data)
	//Kinda annoying but as far as i can tell you need to make actual file.
	var/f = file("data/TempOutfitUpload")
	fdel(f)
	WRITE_FILE(f,json)
	admin << ftp(f,"[name].json")

/// Create an outfit datum from a list of json data
/datum/outfit/proc/load_from(list/outfit_data)
	//This could probably use more strict validation
	name = outfit_data["name"]
	uniform = text2path(outfit_data["uniform"])
	suit = text2path(outfit_data["suit"])
	toggle_helmet = outfit_data["toggle_helmet"]
	back = text2path(outfit_data["back"])
	belt = text2path(outfit_data["belt"])
	gloves = text2path(outfit_data["gloves"])
	shoes = text2path(outfit_data["shoes"])
	head = text2path(outfit_data["head"])
	mask = text2path(outfit_data["mask"])
	neck = text2path(outfit_data["neck"])
	ears = text2path(outfit_data["ears"])
	glasses = text2path(outfit_data["glasses"])
	l_pocket = text2path(outfit_data["l_pocket"])
	r_pocket = text2path(outfit_data["r_pocket"])
	suit_store = text2path(outfit_data["suit_store"])
	r_hand = text2path(outfit_data["r_hand"])
	l_hand = text2path(outfit_data["l_hand"])
	internals_slot = outfit_data["internals_slot"]
	var/list/backpack = outfit_data["backpack_contents"]
	backpack_contents = list()
	for(var/item in backpack)
		var/itype = text2path(item)
		if(itype)
			backpack_contents[itype] = backpack[item]
	box = text2path(outfit_data["box"])
	var/list/impl = outfit_data["implants"]
	implants = list()
	for(var/I in impl)
		var/imptype = text2path(I)
		if(imptype)
			implants += imptype
	accessory = text2path(outfit_data["accessory"])
	return TRUE
