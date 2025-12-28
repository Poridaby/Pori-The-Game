extends Node2D

@onready var hud = $HUD

func turn_player():
	hud.select_action_player()
	
func turn_enemy():
	hud.select_action_enemy()

func _ready():
	var tonar_scene = preload("res://scenes/Perso_fight/Tonar_fight.tscn")
	var tonar_instance = tonar_scene.instantiate()
	var enemy_scene = preload("res://scenes/enemy_fight/Enemy_fight.tscn")
	var enemy_instance = enemy_scene.instantiate()

	# + l'instance au tree (par exemple à Combat)
	add_child(tonar_instance)
	add_child(enemy_instance)

	# Récup Tonar_stats et les stats de l'ennemi
	var tonar_stats: Fighter = tonar_instance.get_node("PersoStats")
	var enemy_stats: Mob = enemy_instance.get_node("EnemyStats")
	
	if tonar_stats.stats.spd > enemy_stats.stats.spd:
		turn_player()
	elif tonar_stats.stats.spd < enemy_stats.stats.spd:
		turn_enemy()
	else:
		var turns = [
			Callable(self, "turn_player"),
			Callable(self, "turn_enemy")
		]
		turns.pick_random().call()
	
	
