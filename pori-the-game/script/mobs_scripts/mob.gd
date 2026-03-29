extends Area2D

@export var id_combat: int

func _process(_delta):
	if overlaps_body($/root/Main/Joueur_P):
		LancerCombat.combattre(id_combat)
