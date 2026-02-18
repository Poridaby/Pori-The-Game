extends Control

@onready var vbox_container = $VBoxContainer

func _ready():
	Inventory.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	
func _on_inventory_updated():
	clear_vbox_container()
	for item in Inventory.inventory:
		if item == null:
			continue
		var icon = TextureRect.new()
		icon.texture = item["texture"]
		icon.size = Vector2(200, 200)
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		vbox_container.add_child(icon)
		var label = Label.new()
		label.text = "%s x%d" % [item["name"], item["quantity"]]
		vbox_container.add_child(label)
	
	
func clear_vbox_container():
	while vbox_container.get_child_count() > 0:
		var child = vbox_container.get_child(0)
		vbox_container.remove_child(child)
		child.queue_free()
