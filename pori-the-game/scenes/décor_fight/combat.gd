extends Node2D

var ennemis_a_spawn = []
var ennemi1_stat = []
var ennemi2_stat = []
var ennemi3_stat = []

func setup_combat(liste_ennemis):
	ennemis_a_spawn = liste_ennemis

func _ready():
	spawn_ennemis()
	print(ennemi1_stat,ennemi2_stat,ennemi3_stat)

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
		if i == 0:
			ennemi1_stat = recup_infos(mob_name)
		elif i == 1:
			ennemi2_stat = recup_infos(mob_name)
		elif i == 2:
			ennemi3_stat = recup_infos(mob_name)

		add_child(mob_instance)


func recup_infos(ennemi):
	var ennemi_possibles = {
		"ptitcrote": preload("res://script/stats/stats_ennemis/ptitcrote.tres"),
		"Carotte_maléfique": preload("res://script/stats/stats_ennemis/carotte_maléfique.tres"),
	}

	var ennemi_stats = ennemi_possibles[ennemi]
	var pv = ennemi_stats.pv
	var pm = ennemi_stats.pm
	var atk = ennemi_stats.atk
	var def = ennemi_stats.def
	var spd = ennemi_stats.spd
	var pierre = ennemi_stats.pierre
	
	return  [pv, pm, atk, def, spd, pierre]
