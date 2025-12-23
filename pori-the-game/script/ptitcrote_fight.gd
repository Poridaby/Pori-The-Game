extends Node

@export var stats: Stats
var pv_max: int
var pv: int
var pm_max: int
var pm: int
var atk: int
var def: int
var spd: int
var pierre: int

func _ready():
	pv = stats.pv_max
	pm = stats.pm_max
	atk = stats.atk
	def = stats.def
	spd = stats.spd
	pierre = stats.pierre
