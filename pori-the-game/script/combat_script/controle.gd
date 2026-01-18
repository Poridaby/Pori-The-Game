extends Control

@onready var hud_node = get_node("/root/Combat")

func select_action_player():
	# permet de naviguer entre les différentes actions
	$attack.grab_focus()

func _on_attack_pressed():
	hud_node.hud.visible = false
	hud_node.sub.visible = true
	$"../submenu/pass".visible = false
	$"../submenu/attack_1".grab_focus()
	
func _on_attack_1_pressed():
	var multi = 1
	$"../submenu/attack_1".visible = false
	$"../submenu/pass".visible = true
	hud_node.damage_to_enemy(multi)
	$"../submenu/pass".grab_focus()
	
func _on_special_pressed():
	print("choisi ton attaque spécial fdp")

func _on_health_pressed():
	print("choisi ton objet fdp")

func _on_run_pressed():
	print("BAAAHHH LE NULOS IL FUIT")
	
func select_action_enemy():
	hud_node.damage_to_player()

func _on_pass_pressed():
	hud_node.end_or_not()
