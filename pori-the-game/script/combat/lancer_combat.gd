extends Node

@export var stats_class_local: combat_class

func _ready():
	var infos = recup_infos(0)


func recup_infos(id_combat):
	var combats_possibles = [
	preload("res://script/stats/ressource combat/test.tres"),
]
	# Renvoie la bonne ressource
	var combat = combats_possibles[id_combat]
	var scene = combat.scene
	var nbr_ennemi = combat.nbr_ennemi
	var region = combat.region
	var ennemi_principal = combat.ennemi_pricipal
	return [scene, nbr_ennemi, region, ennemi_principal]
