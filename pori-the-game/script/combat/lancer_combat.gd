# Script dans l'autoload, la fonction combattre est utilisable partout
extends Node

@export var stats_class_local: combat_class

# Récupère les infos d'un combat par son ID
func recup_infos(id_combat):
	# Liste contenant tous les .tres de combats (assure-toi que les chemins sont valides)
	var combats_possibles = [
		preload("res://script/stats/ressource combat/test.tres"),
		preload("res://script/stats/ressource combat/ptitcrote_1.tres")
	]
	
	# Vérifier que l'ID est valide
	if id_combat < 0 or id_combat >= combats_possibles.size():
		push_error("ID de combat invalide : ", id_combat)
		return null
	
	var combat = combats_possibles[id_combat]
	if combat == null:
		push_error("La ressource de combat à l'index ", id_combat, " est null")
		return null
	
	# Renvoie les infos du combat
	return [
		combat.scene,
		combat.nbr_ennemi,
		combat.region,
		combat.ennemi_principal
	]

# Fonction appelée par les scripts pour lancer un combat
func combattre(id_combat):
	# Récupère les infos du combat
	var combat_data = recup_infos(id_combat)
	if combat_data == null:
		push_error("Impossible de récupérer les données du combat (ID: ", id_combat, ")")
		return
	
	# Variables
	var regions = {
		"inserelenon": ["ptitcrote", "Carotte_maléfique"]
		# Ajoute d'autres régions ici
	}
	
	var scene = combat_data[0]
	var nbr_ennemi = combat_data[1]
	var region_actuelle = combat_data[2]
	var ennemi_principal = combat_data[3]
	
	# Vérifier que la scène est valide
	if scene == null:
		push_error("La scène de combat est null !")
		return
	
	# Récupérer la liste des mobs de la région
	var mob_region = regions.get(region_actuelle, [])
	if mob_region.is_empty():
		push_warning("Aucun ennemi trouvé pour la région : ", region_actuelle, " -> fallback sur [ptitcrote]")
		mob_region = ["ptitcrote"]   # fallback
	
	var ennemis = []
	
	for i in range(nbr_ennemi):
		if i == 0:
			# Premier ennemi = celui touché
			ennemis.append(ennemi_principal)
		else:
			# Ennemis supplémentaires aléatoires
			var choix = mob_region.pick_random()
			if choix == null:
				push_warning("Pas d'ennemi aléatoire disponible, fallback sur ptitcrote")
				choix = "ptitcrote"
			ennemis.append(choix)
	
	# Debug
	print("Lancement du combat avec ennemis : ", ennemis)
	
	# Instancier la scène de combat
	var combat_instance = scene.instantiate()
	if combat_instance == null:
		push_error("Échec de l'instanciation de la scène de combat")
		return
	
	# Vérifier que la scène a bien la méthode setup_combat
	if not combat_instance.has_method("setup_combat"):
		push_error("La scène de combat n'a pas de méthode setup_combat")
		return
	
	combat_instance.setup_combat(ennemis)
	
	# Changer de scène
	var previous_scene = get_tree().current_scene
	if previous_scene:
		previous_scene.queue_free()
	
	get_tree().root.add_child(combat_instance)
	get_tree().current_scene = combat_instance
