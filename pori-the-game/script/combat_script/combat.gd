extends Node2D

@onready var hud = $HUD
@onready var sub = $submenu
var rng := RandomNumberGenerator.new()
var tonar_scene = preload("res://scenes/Perso_fight/Tonar_fight.tscn")
var tonar_instance = tonar_scene.instantiate()
var enemy_scene = preload("res://scenes/enemy_fight/Enemy_fight.tscn")
var enemy_instance = enemy_scene.instantiate()

# Récup Tonar_stats et les stats de l'ennemi
var tonar_stats: Fighter = tonar_instance.get_node("PersoStats")
var enemy_stats: Mob = enemy_instance.get_node("EnemyStats")
	
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
	rng.randomize() 
	hud.visible = false
	
	# Intance les scenes au tree
	add_child(tonar_instance)
	add_child(enemy_instance)
	tonar_instance.visible = false
	enemy_instance.visible = false
	
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

func crit():
	var base_chance = 0.05  # 5% de base
	var scaling = 0.01      # +1% par point de stat
	var crit_chance = base_chance + tonar_stats.stats.pierre * scaling
	crit_chance = clamp(crit_chance, 0.0, 1.0)  # pas plus de 100%
	return rng.randf() < crit_chance # déclenche la chance de critique

func damage_to_enemy(multi):
	# Calcul les dégâts subit par l'ennemi et vérifie si il est mort et si il doit subir un crit
	var dmg = (tonar_stats.stats.atk - enemy_stats.stats.def) * multi
	if crit():
		dmg = int(dmg * 1.5)
	enemy_stats.stats.pv -= dmg
	if enemy_stats.stats.pv <= 0:
		print("ENNEMI VAINCU MOTHERFUCKER")
	else:
		print("OOOUUUUFFF CA DOIT FAIRE MAL")
