extends Node
class_name StatsManager

var stats: Stats = Stats.new()
const SAVE_PATH := "user://player_stats.json"

func _ready():
	load_stats()

func load_stats():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) != TYPE_ARRAY:
		return

	stats.name    = data[0]
	stats.pv_max  = data[1]
	stats.pv      = data[2]
	stats.pm_max  = data[3]
	stats.pm      = data[4]
	stats.atk     = data[5]
	stats.def     = data[6]
	stats.spd     = data[7]
	stats.pierre  = data[8]

func save_stats():
	var data := [
		stats.name,
		stats.pv_max,
		stats.pv,
		stats.pm_max,
		stats.pm,
		stats.atk,
		stats.def,
		stats.spd,
		stats.pierre
	]

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func _exit_tree():
	save_stats()
