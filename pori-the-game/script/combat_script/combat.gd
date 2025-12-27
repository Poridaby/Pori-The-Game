extends Node2D

func turn_player():
	pass
	
func turn_enemy():
	pass

func _ready():
	var tonar_scene = preload("res://scenes/Perso_fight/Tonar_fight.tscn")
	var tonar_instance = tonar_scene.instantiate()
	var enemy_scene = preload("res://scenes/enemy_fight/Enemy_fight.tscn")
	var enemy_instance = enemy_scene.instantiate()

	# Tu ajoutes l'instance au tree (par exemple à Combat)
	add_child(tonar_instance)
	add_child(enemy_instance)

	# Récup Tonar_stats
	var tonar_stats: TonarStats = tonar_instance.get_node("PersoStats")
	var enemy_stats: Ptitcrote = enemy_instance.get_node("EnemyStats")
	
	if tonar_stats.stats.spd > enemy_stats.stats.spd:
		print("AU TOUR DE TONAR !!")
	elif tonar_stats.stats.spd < enemy_stats.stats.spd:
		print("AU TOUR DE PTITCROTE !!")
	
	
