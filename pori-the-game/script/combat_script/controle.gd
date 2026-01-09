extends Control

@onready var hud_node = get_node("/root/Combat")
var tonar_scene = preload("res://scenes/Perso_fight/Tonar_fight.tscn")
var tonar_instance = tonar_scene.instantiate()
var enemy_scene = preload("res://scenes/enemy_fight/Enemy_fight.tscn")
var enemy_instance = enemy_scene.instantiate()

# Récup Tonar_stats et les stats de l'ennemi
var tonar_stats: Fighter = tonar_instance.get_node("PersoStats")
var enemy_stats: Mob = enemy_instance.get_node("EnemyStats")

func _ready():
	# Intance les scenes au tree
	add_child(tonar_instance)
	add_child(enemy_instance)
	tonar_instance.visible = false
	enemy_instance.visible = false

func select_action_player():
	# permet de naviguer entre les différentes actions
	$attack.grab_focus()

func _on_attack_pressed():
	hud_node.hud.visible = false
	hud_node.sub.visible = true
	$"../submenu/pass".visible = false
	$"../submenu/attack_1".grab_focus()
	
func _on_attack_1_pressed():
	var multi = 1
	$"../submenu/attack_1".visible = false
	$"../submenu/pass".visible = true
	hud_node.damage_to_enemy(multi)
	$"../submenu/pass".grab_focus()
	
func _on_special_pressed():
	print("choisi ton attaque spécial fdp")

func _on_health_pressed():
	print("choisi ton objet fdp")

func _on_run_pressed():
	print("BAAAHHH LE NULOS IL FUIT")
	
func select_action_enemy():
	print("l'aléatoire fera les choses")

func _on_pass_pressed():
	if enemy_stats.stats.pv <= 0:
		get_tree().change_scene_to_file("res://scenes/décor_explo/Inser_ellenon.tscn")
	else:
		$"../submenu/pass".visible = false
		hud_node.turn_enemy()
