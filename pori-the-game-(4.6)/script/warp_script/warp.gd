extends Node2D

@export var next_scene_right: String = "res://scenes/plaine.tscn"
@export var next_scene_left: String = "res://scenes/Inser_ellenon.tscn"

func _on_exit_body_entered(body):
	"""
	teleporte de inser_ellenon vers plaine
	:comportement: change de scène
	"""
	if body is Player:
		global_var.next_spawn_name = "SpawnerLeft"
		call_deferred("_go_to_plaine")
		
func _go_to_plaine():
	get_tree().change_scene_to_file("res://scenes/décor_explo/plaine.tscn")

func _on_exit_left_body_entered(body):
	"""
	teleporte de plaine vers inser_ellenon
	:comportement: change de scène
	"""
	if body is Player:
		global_var.next_spawn_name = "SpawnerRight"
		call_deferred("_go_to_Inser_ellenon")
		
func _go_to_Inser_ellenon():
	get_tree().change_scene_to_file("res://scenes/décor_explo/Inser_ellenon.tscn")
