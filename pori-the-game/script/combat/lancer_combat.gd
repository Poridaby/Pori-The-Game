extends Node

@export var stats_class_local: combat_class

func _ready():
	var infos = recup_infos(0)


func recup_infos(id_combat):
	var combats_possibles = [
	preload("res://script/stats/ressource combat/test.tres"),
]

	print(combats_possibles)
	var combat = combats_possibles[id_combat]
	return combat.scene
