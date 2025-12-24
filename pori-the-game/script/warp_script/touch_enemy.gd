extends Node


func _on_body_entered(body):
	if body is Player:
		call_deferred("_go_to_combat")

func _go_to_combat():
	get_tree().change_scene_to_file("res://scenes/décor_fight/combat.tscn")
