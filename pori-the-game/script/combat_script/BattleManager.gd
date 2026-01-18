extends Node

var enemy_runtime_stats: Stats
var player_runtime_stats: Stats
var enemy_runtime_attack: Attack

func start_battle(enemy_base_stats: Stats, enemy_attack: Attack) -> void:
	enemy_runtime_stats = enemy_base_stats.duplicate(true)
	enemy_runtime_attack = enemy_attack.duplicate(true)
	player_runtime_stats = PlayerManager.player_base_stats.duplicate(true)

	get_tree().change_scene_to_file("res://scenes/décor_fight/combat.tscn")
