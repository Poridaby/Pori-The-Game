extends Node

var enemy_runtime_stats: Stats
var player_runtime_stats: Stats

func start_battle(enemy_base_stats: Stats) -> void:
	enemy_runtime_stats = enemy_base_stats.duplicate(true)
	player_runtime_stats = PlayerManager.player_base_stats.duplicate(true)

	get_tree().change_scene_to_file("res://scenes/décor_fight/combat.tscn")
