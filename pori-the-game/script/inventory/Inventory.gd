extends Node

# Variable de l'inventaire
var inventory = []

# Signals customes
signal inventory_updated

# Scene et Node Référence
var player_node: Node = null

func _ready():
	# Le stockage de l'inventaire est initialisé à 30 slots
	inventory.resize(30)

# Rajoute un item dans l'inventaire
func add_item():
	inventory_updated.emit()
	
# Retire un item de l'inventaire
func remove_item():
	inventory_updated.emit()
	
# Augmente le nombre de slots de l'inventaire dynamiquement
func increase_inventory_size():
	inventory_updated.emit()


func set_player_reference(player):
	player_node = player
