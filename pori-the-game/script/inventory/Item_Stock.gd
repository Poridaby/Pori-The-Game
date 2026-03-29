extends Control
class_name InventoryUI

@onready var vbox_container = $VBoxContainer
@onready var vbox_label = $VBoxContainer2
var first_button : Button 


func _ready():
	# Reçois le signal permettant de mettre à jour l'inventaire
	Inventory.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	
	

func _on_inventory_updated():
	# Vide l'inventaire pour rajouter les items en plus avec leur icone et leur nom
	clear_vbox_container()
	first_button = Button.new()
	first_button.text = "Select"
	$VBoxContainer.add_child(first_button)
	first_button.grab_focus()
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
		# Crée un bouton pour sélectionner les items
		var button = Button.new()
		button.text = "%s x%d" % [item["name"], item["quantity"]]
		button.pressed.connect(select_item.bind(item))
		hbox.add_child(button)

func select_item(itemm):
	clear_vbox_label()
	var label = Label.new()
	label.text =  "{0}:  {1}".format([itemm["name"], itemm["effect"]])
	vbox_label.add_child(label)
	
func clear_vbox_container():
	# Vide complètement l'inventaire
	while vbox_container.get_child_count() > 0:
		var child = vbox_container.get_child(0)
		vbox_container.remove_child(child)
		child.queue_free()
		
func clear_vbox_label():
	# Vide complètement l'inventaire
	while vbox_label.get_child_count() > 0:
		var child = vbox_label.get_child(0)
		vbox_label.remove_child(child)
		child.queue_free()
