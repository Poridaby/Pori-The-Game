extends Node2D

@export var next_scene_right:String
@export var next_scene_left:String


#func _on_exit_body_entered(_body: Node2D) -> void:
	#"""
	#Teleporte le joueur d'une zone a l'autre
	#:comportement: change de scene
	#"""
	#var next_scene = load(next_scene_right)
	#var next_scene_instances = next_scene.instantiate()
	#next_scene_instances.init_player_position(Vector2.RIGHT)
	#get_tree().root.add_child(next_scene_instances)
	#queue_free()

#func _on_exit_left_body_entered(_body: Node2D) -> void:
	#"""
	#Teleporte le joueur d'une zone a l'autre
	#:comportement: change de scene
	#"""
	#var next_scene = load(next_scene_left)
	#var next_scene_instances = next_scene.instantiate()
	#next_scene_instances.init_player_position(Vector2.LEFT)
	#get_tree().root.add_child(next_scene_instances)
	#queue_free()
	


#func init_player_position(direction: Vector2):
	#"""
	#Choisi ou faire apparaitre de joueur
	#:comportement: choisi le bon spawner pour le joueur
	#"""
	#if direction == Vector2.RIGHT:
		#$Joueur_P.position = $SpawnerLeft.position
	#elif direction == Vector2.LEFT:
		#$Joueur_P.position = $SpawnerRight.position
		


func _on_exit_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/plaine.tscn")
		global_position = Vector2.ZERO


func _on_exit_left_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://scenes/Inser_ellenon.tscn")
		
