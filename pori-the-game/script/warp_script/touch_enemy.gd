extends Area2D
class_name Enemy

@export var base_stats: Stats

func _on_body_entered(body):
	if body is Player:
		call_deferred("_go_to_combat")

func _go_to_combat():
	BattleManager.start_battle(base_stats)
