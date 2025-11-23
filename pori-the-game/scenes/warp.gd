extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_exit_body_entered(body: Node2D) -> void:
	var next_scene = load("res://scenes/plaine.tscn")
	var next_scene_instances = next_scene.instantiate()
	next_scene_instances.init_player_position(Vector2.RIGHT)
	get_tree().root.add_child(next_scene_instances)
	queue_free()
	
func init_player_position(direction: Vector2):
	if direction == Vector2.RIGHT:
		$Joueur_P.position = $SpawnerLeft.position
	elif direction == Vector2.LEFT:
		$Joueur_P.position = $SpawnerRight.position
		
