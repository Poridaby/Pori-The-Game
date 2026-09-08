extends Node

# Variable de l'inventaire
var inventory = []
var inventory_equipement = []
var inventory_cle = []

# Scene et Node Référence
var player_node: Node = null
@onready var scene_inventory = preload("res://scenes/décor_explo/InventoryUI.tscn")
# Signals customes
signal inventory_updated

func _ready():
	# Le stockage de l'inventaire est initialisé à 30 slots
	inventory.resize(100)
	inventory_equipement.resize(100)
	inventory_cle.resize(100)
	
# Rajoute un item dans l'inventaire
func add_item(item, inventaire):
		for i in range(inventaire.size()):
			# Check si l'item existe dans l'inventaire et matche avec le type et l'effet
			if inventaire[i] != null and inventaire[i]["type"] == item["type"] and inventaire[i]["effect"] == item["effect"] and inventaire[i]["name"] == item["name"]:
				inventaire[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				return true
			elif inventaire[i] == null:
				inventaire[i] = item
				inventory_updated.emit()
				return true
		return false
	
# Retire un item de l'inventaire
func remove_item(item, amount:=1):
		for i in range(inventory.size()):
			if inventory[i] != null \
			and inventory[i]["type"] == item["type"] \
			and inventory[i]["effect"] == item["effect"]:

				inventory[i]["quantity"] -= amount

				# Si il n'en reste plus, on vide la case
				if inventory[i]["quantity"] <= 0:
					inventory[i] = null

				inventory_updated.emit()
				return true

		return false
		
# Augmente le nombre de slots de l'inventaire dynamiquement
func increase_inventory_size():
	inventory_updated.emit()

# Référence de la variable joueur
func set_player_reference(player):
	player_node = player
