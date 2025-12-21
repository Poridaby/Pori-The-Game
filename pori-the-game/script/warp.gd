extends Node2D

@export var next_scene_right: String = "res://scenes/plaine.tscn"
@export var next_scene_left: String = "res://scenes/Inser_ellenon.tscn"

func _on_exit_body_entered(body):
	if body is Player:
		global_var.next_spawn_name = "SpawnerLeft"
		get_tree().change_scene_to_file("res://scenes/plaine.tscn")

func _on_exit_left_body_entered(body):
	if body is Player:
		global_var.next_spawn_name = "SpawnerRight"
		get_tree().change_scene_to_file("res://scenes/Inser_ellenon.tscn")
