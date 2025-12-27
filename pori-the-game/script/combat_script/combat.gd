extends Node

@onready var hud: Control = $HUD
@onready var tonar_fight_scene := preload("res://scenes/Perso_fight/Tonar_fight.tscn")

func _ready():
	var tonar_fight = tonar_fight_scene.instantiate()
	add_child(tonar_fight)

	var perso_stats: Tonar = tonar_fight.get_node("PersoStats")
	hud.set_perso_stats(perso_stats)
