extends Node2D

func take_damage(amount: int):
	global_var.stats_1["PV"] = max(global_var.stats_1["PV"]- amount, 0)
