extends Node

# Variable de l'inventaire
var inventory = []

# Signals customes
signal inventory_updated

func _ready():
	# Le stockage de l'inventaire est initialisé à 30 slots
	inventory.resize(30)
