extends Node
class_name Enemy

var stats := {
	"name": "",
	"lvl":1,
	"XP":0,
	"PV_max":10,
	"PV":10,
	"PM_max":10,
	"PM":10,
	"ATK":10,
	"DEF":10,
	"SPEED":9,
	"PIERRE":10,
	}

func ouch(degats: int):
	var dmg = max(degats - stats["DEF"], 0)
	stats["PV"] -= dmg
