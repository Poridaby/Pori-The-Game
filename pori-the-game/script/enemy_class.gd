extends CharacterBody2D
class_name Enemy

@export var stats: Stats
var pv: int
var pm: int
var atk: int
var def: int
var spd: int
var pierre: int

func _ready():
	name = stats.name
	pv = stats.pv_max
	pm = stats.pm_max
	atk = stats.atk
	def = stats.def
	spd = stats.spd
	pierre = stats.pierre
