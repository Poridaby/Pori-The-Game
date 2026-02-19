extends Control

@onready var vbox_container = $VBoxContainer

func _ready():
	# Reçois le signal permettant de mettre à jour l'inventaire
	Inventory.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	

func _on_inventory_updated():
	# Vide l'inventaire pour rajouter les items en plus avec leur icone et leur nom
	clear_vbox_container()
	# Ignore les valeur null de la liste
	for item in Inventory.inventory:
		if item == null:
			continue
		# Crée pour chaque item un hbox container pour que ça soit jolie
		var hbox = HBoxContainer.new()
		vbox_container.add_child(hbox)
		# Crée une icone pour chaque item qui rentre dans l'inventaire
		var icon = TextureRect.new()
		icon.texture = item["texture"]
		icon.custom_minimum_size = Vector2(64, 64)
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hbox.add_child(icon)
		# Crée un texte qui correspond au nom de l'item
		var label = Label.new()
		label.text = "%s x%d" % [item["name"], item["quantity"]]
		hbox.add_child(label)
	
	
func clear_vbox_container():
	# Vide complètement l'inventaire
	while vbox_container.get_child_count() > 0:
		var child = vbox_container.get_child(0)
		vbox_container.remove_child(child)
		child.queue_free()
