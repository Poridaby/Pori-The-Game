extends Resource
class_name Stats

@export var name:= "Tonar"
@export var pv_max: int = 10
@export var pm_max: int = 10
@export var atk: int = 2
@export var def: int = 1
@export var spd: int = 1
@export var pierre: int = 9
@export var battle_sprite: Texture2D

var pv: int
var pm: int

func _init():
	pv = pv_max

func reset():
	pv = pv_max
