/datum/round_event_control/troll
	name = "troll chance increaase"
	typepath = /datum/round_event/troll
	weight = 20
	max_occurrences = 25
	min_players = 10
	alert_observers = FALSE


/datum/round_event/troll
	fakeable = FALSE
	announceChance = 0


/datum/round_event/troll/start()
	SSevents.troll_spawn_change += 0.1
