extends Node

@export var stats_class_local: combat_class

func _ready():
	var infos = recup_infos(0)


func recup_infos(id_combat):
	var combats_possibles = ["test"]
	print(combats_possibles)
	var combat = combats_possibles[id_combat]
	print(combat)
	var scene = combat.combat_class.scene
	return scene
