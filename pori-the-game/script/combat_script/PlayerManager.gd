extends Node

@export var player_base_stats: Stats

func _ready():
	player_base_stats = load("res://script/class_script/TonarStats.tres")
