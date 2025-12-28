extends Node2D

@onready var hud = $HUD
@onready var sub = $submenu

func turn_player():
	# Rend visible l'HUD et lance la fonction de sélection d'action
	hud.visible = true
	sub.visible = false
	hud.select_action_player()
	
func turn_enemy():
	# Rend invisible l'HUD et lance la fonction d'action de l'ennemi
	hud.visible = false
	hud.select_action_enemy()

func _ready():
	hud.visible = false
	var tonar_scene = preload("res://scenes/Perso_fight/Tonar_fight.tscn")
	var tonar_instance = tonar_scene.instantiate()
	var enemy_scene = preload("res://scenes/enemy_fight/Enemy_fight.tscn")
	var enemy_instance = enemy_scene.instantiate()

	# Intance les scenes au tree
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
	
	
