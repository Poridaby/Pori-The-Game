extends Node2D

# Initialisation des variables globales au script
var ennemis_a_spawn = []
var ennemi1_stats = null
var ennemi2_stats = null
var ennemi3_stats = null

# Fonction qui récupère les ennemis a générer
func setup_combat(liste_ennemis):
	ennemis_a_spawn = liste_ennemis


func _ready():
	spawn_ennemis()
	# Utile au tests
	print(ennemi1_stats,ennemi2_stats,ennemi3_stats)

# Fait apparaître les ennemis sur leurs spawners et récupère leurs stats
func spawn_ennemis():
	# Liste contenant les spawners
	var spawners = $Spawners_ennemi.get_children()
	var stats = []

	for i in range(ennemis_a_spawn.size()):

		# Récupère l'ennemi actuel
		var mob_name = ennemis_a_spawn[i]
		# Le fait apparaite sur son spawner
		var mob_scene = load("res://scenes/enemy_combat/" + mob_name + ".tscn")

		if mob_scene == null:
			push_error("Mob introuvable : " + mob_name)
			continue

		var mob_instance = mob_scene.instantiate()
		mob_instance.global_position = spawners[i].global_position
		
		# Récupère les stats de chaques mobs
		stats.append(recup_infos(mob_name))

		add_child(mob_instance)
	
	# Stocke les stats de chaques mobs individuellement
	ennemi1_stats = stats[0]
	ennemi2_stats = stats[1]
	ennemi3_stats = stats[2]


func recup_infos(ennemi):
	var ennemi_possibles = {
		"ptitcrote": preload("res://script/stats/stats_ennemis/ptitcrote.tres"),
		"Carotte_maléfique": preload("res://script/stats/stats_ennemis/carotte_maléfique.tres"),
	}

	var ennemi_stats = ennemi_possibles[ennemi]
	var pv = ennemi_stats.pv
	var pm = ennemi_stats.pm
	var atk = ennemi_stats.atk
	var def = ennemi_stats.def
	var spd = ennemi_stats.spd
	var pierre = ennemi_stats.pierre
	
	return  [pv, pm, atk, def, spd, pierre]
