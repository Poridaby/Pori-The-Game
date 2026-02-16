extends Node2D

var ennemis_a_spawn = []

func setup_combat(liste_ennemis):
	ennemis_a_spawn = liste_ennemis

func _ready():
	spawn_ennemis()

func spawn_ennemis():

	var spawners = $Spawners_ennemi.get_children()

	for i in range(ennemis_a_spawn.size()):

		var mob_name = ennemis_a_spawn[i]
		var mob_scene = load("res://scenes/enemy_combat/" + mob_name + ".tscn")

		if mob_scene == null:
			push_error("Mob introuvable : " + mob_name)
			continue

		var mob_instance = mob_scene.instantiate()
		mob_instance.global_position = spawners[i].global_position

		add_child(mob_instance)
