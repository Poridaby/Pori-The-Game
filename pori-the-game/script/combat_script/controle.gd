extends Control

@onready var b_attack = $attack
@onready var attack_select = $"../submenu/attack_1"
@onready var hud_node = get_node("/root/Combat")

func select_action_player():
	# permet de naviguer entre les différentes actions
	b_attack.grab_focus()

func _on_attack_pressed():
	hud_node.hud.visible = false
	hud_node.sub.visible = true
	attack_select.grab_focus()
	
func _on_attack_1_pressed():
	print("OOOUUUUUHHH ça doit faire mal")
	
func _on_special_pressed():
	print("choisi ton attaque spécial fdp")

func _on_health_pressed():
	print("choisi ton objet fdp")

func _on_run_pressed():
	print("BAAAHHH LE NULOS IL FUIT")
	
func select_action_enemy():
	print("l'aléatoire fera les choses")
