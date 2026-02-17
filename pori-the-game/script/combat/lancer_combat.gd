extends Node

@export var stats_class_local: combat_class

# Fonction appelée par les script a chaque moments ou il faut lancer un combat avec LancerCombat.combattre(id_combat)
func combattre(id_combat):

	# Mettre ici toutes les régions du jeu avec les énnemis possibles dedans
	var regions = {
		"inserelenon": ["ptitcrote", "Carotte_maléfique"]
	}

	# La variable combat stocke toutes les infos du combat a lancer
	var combat = recup_infos(id_combat)

	var scene = combat[0]
	var nbr_ennemi = combat[1]
	var region_actuelle = combat[2]
	var ennemi_principal = combat[3]

	var mob_region = regions.get(region_actuelle, [])

	var ennemis = []

	for i in range(nbr_ennemi):
		if i == 0:
			ennemis.append(ennemi_principal)
		else:
			ennemis.append(mob_region.pick_random())

	var combat_instance = scene.instantiate()
	combat_instance.setup_combat(ennemis)

	get_tree().current_scene.queue_free()
	get_tree().root.add_child(combat_instance)
	get_tree().current_scene = combat_instance


func recup_infos(id_combat):

	var combats_possibles = [
		preload("res://script/stats/ressource combat/test.tres")
	]

	var combat = combats_possibles[id_combat]

	return [
		combat.scene,
		combat.nbr_ennemi,
		combat.region,
		combat.ennemi_principal
	]
