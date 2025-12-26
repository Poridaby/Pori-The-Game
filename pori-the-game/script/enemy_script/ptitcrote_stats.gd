extends Node

@export var stats: Stats

func _ready():
	#EMPECHE L'ERREUR DE FDP DE NIL !!!
	if stats == null:
		stats = Stats.new()
	
	#Initialise les stats du mob et son nom
	stats.name = "Ptitcrote"
	stats.pv_max = 15
	stats.pm_max = 10
	stats.atk = 6
	stats.def = 4
	stats.spd = 8
	stats.pierre = 9
	stats.pv = stats.pv_max
	stats.pm = stats.pm_max
