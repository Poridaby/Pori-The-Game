extends Node

@export var stats: Stats

func _ready():
	#EMPECHE L'ERREUR DE FDP DE NIL !!!
	if stats == null:
		stats = Stats.new()
	
	#Initialise les stats du perso et son nom
	stats.name = "Tonar"
	stats.pv_max = 16
	stats.pm_max = 12
	stats.atk = 11
	stats.def = 9
	stats.spd = 11
	stats.pierre = 6
	stats.pv = stats.pv_max
	stats.pm = stats.pm_max
