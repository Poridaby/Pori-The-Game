extends Area2D
class_name Enemy

@export var stats: Stats

func _on_body_entered(body):
	if body is Player:
		call_deferred("_go_to_combat")

func _go_to_combat():
	 # Instancier le joueur depuis sa scène template si jamais il n'existe pas
	if BattleManager.current_player == null:
		var player_scene = preload("res://scenes/Perso_explo/Tonar.tscn")
		var player_instance = player_scene.instantiate()
		BattleManager.current_player = player_instance

	# Cloner les stats de l'ennemi
	BattleManager.current_enemy_stats = self.stats.duplicate(true)

	get_tree().change_scene_to_file("res://scenes/décor_fight/combat.tscn")
