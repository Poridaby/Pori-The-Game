extends Node

@export var stats_class_local: combat_class

func combattre():
	var regions = [["inserelenon",["ptitcrote","Carotte_maléfique"]]
		]
	var combat = recup_infos(0)
	get_tree().change_scene_to_packed(combat[0])
	var nbr_ennemi = combat[1]
	var region_actuelle = combat[2]
	var ennemi_principal = combat[3]
	var mob_region = ["ennemie shiny de fou malade ultra rare (impossible a avoir)"]

	for region in regions:
			if region[0] == region_actuelle:
				mob_region = region[1]
	
	var ennemis = []
	for i in range(0, nbr_ennemi):
		if i == 0:
			ennemis.append(ennemi_principal)
		else:
			ennemis.append(mob_region.pick_random())
	


func recup_infos(id_combat):
	var combats_possibles = [
	preload("res://script/stats/ressource combat/test.tres"),
]
	# Renvoie la bonne ressource
	var combat = combats_possibles[id_combat]
	var scene = combat.scene
	var nbr_ennemi = combat.nbr_ennemi
	var region = combat.region
	var ennemi_principal = combat.ennemi_principal
	return [scene, nbr_ennemi, region, ennemi_principal]
