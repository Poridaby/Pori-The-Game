extends Node

# Variable de l'inventaire
var inventory = []

# Scene et Node Référence
var player_node: Node = null

# Signals customes
signal inventory_updated

func _ready():
	# Le stockage de l'inventaire est initialisé à 30 slots
	inventory.resize(30)

# Rajoute un item dans l'inventaire
@warning_ignore("unused_parameter")
func add_item(item):
	for i in range(inventory.size()):
		# Check si l'item existe dans l'inventaire et matche avec le type et l'effet
		if inventory[i] != null and inventory[i]["type"] == item["item"] and inventory[i]["effect"] == item["item"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
		return false
	
# Retire un item de l'inventaire
func remove_item():
	inventory_updated.emit()
	
# Augmente le nombre de slots de l'inventaire dynamiquement
func increase_inventory_size():
	inventory_updated.emit()


func set_player_reference(player):
	player_node = player
