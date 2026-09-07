extends Control
class_name InventoryUI

@onready var vbox_objet = $VBoxContainer
@onready var vbox_equipement = $VBoxContainer3
@onready var vbox_cle = $VBoxContainer4
@onready var vbox_label = $VBoxContainer2
var item_select



func _ready():
	# Reçois le signal permettant de mettre à jour l'inventaire
	Inventory.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	$Button.visible = false
	$Button.pressed.connect(_button_pressed)
	$Button2.pressed.connect(_button2_pressed)
	$Button3.pressed.connect(_button3_pressed)
	
func _physics_process(_delta):
	$AnimatedSprite2D.play("Tonar_anim_inv")
	
func _input(event):
	if event.is_action_pressed("close_inventory"):
		clear_vbox_label()
		get_tree().paused = false
		$"..".visible = false

func _on_inventory_updated():
		# Vide l'inventaire pour rajouter les items en plus avec leur icone et leur nom
		clear_vbox_container(vbox_objet)
		clear_vbox_container(vbox_equipement)
		# Consommables
		for item in Inventory.inventory:
			if item == null:
				continue

			if item["type"] == "Consomable":
				ajout_objet(item, vbox_objet)
				print("oui")

		# Équipements
		for item in Inventory.inventory_equipement:
			if item == null:
				continue
				
			if item["type"] == "Equipement":
				ajout_objet(item, vbox_equipement)
		

func ajout_objet(item, vbox):
	var hbox = HBoxContainer.new()
	vbox.add_child(hbox)

	var icon = TextureRect.new()
	icon.texture = item["texture"]
	icon.custom_minimum_size = Vector2(64, 64)
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	hbox.add_child(icon)

	var button = Button.new()
	button.text = "%s x%d" % [item["name"], item["quantity"]]
	button.pressed.connect(select_item.bind(item))
	hbox.add_child(button)


func select_item(item):
	$Button.visible = true
	$Button.grab_focus()
	item_select = item
	
	
func _button_pressed():
	print("Avant PV:", global_var.Tonar_stats.pv)
	print("Avant PM:", global_var.Tonar_stats.pm)
	if item_select["type"] == "Consomable":
		clear_vbox_label()
		popup_invent("Vous avez consommé l'item !")
		match item_select["effect"]:
			"heal_pv":
				global_var.Tonar_stats.pv = min(global_var.Tonar_stats.pv + item_select["effect_value"], global_var.Tonar_stats.pv_max)
			"heal_pm":
				global_var.Tonar_stats.pm = min(global_var.Tonar_stats.pm + item_select["effect_value"], global_var.Tonar_stats.pm_max)
		print("Après PV", global_var.Tonar_stats.pv)
		print("Après PM", global_var.Tonar_stats.pm)
		Inventory.remove_item(item_select)
		$Button.visible = false
		$Button2.call_deferred("grab_focus")
	elif item_select["type"] == "Equipement":
		if not item_select["equiped"]:
			clear_vbox_label()
			popup_invent("L'équipement a été équipé !")
			match item_select["stat"]:
				"def":
					print(global_var.Tonar_stats.def)
					global_var.Tonar_stats.def += item_select["stat_value"]
					item_select["equiped"] = true
					print(global_var.Tonar_stats.def)
				"atk":
					print(global_var.Tonar_stats.atk)
					global_var.Tonar_stats.atk += item_select["stat_value"]
					item_select["equiped"] = true
					print(global_var.Tonar_stats.atk)
		else:
			clear_vbox_label()
			popup_invent("L'équipement a été retiré !")
			match item_select["stat"]:
				"def":
					global_var.Tonar_stats.def -= item_select["stat_value"]
					print(global_var.Tonar_stats.def)
				"atk":
					global_var.Tonar_stats.atk -= item_select["stat_value"]
					print(global_var.Tonar_stats.atk)
				"spd":
					global_var.Tonar_stats.spd -= item_select["stat_value"]
			item_select["equiped"] = false
	
func _button2_pressed():
	$VBoxContainer.visible = true
	$VBoxContainer3.visible = false
	
func _button3_pressed():
	$VBoxContainer.visible = false
	$VBoxContainer3.visible = true
	
func popup_invent(texte):
	var label = Label.new()
	label.text = texte
	vbox_label.add_child(label)
	
func clear_vbox_container(vbox):
	# Vide complètement l'inventaire
	while vbox.get_child_count() > 0:
		var child = vbox.get_child(0)
		vbox.remove_child(child)
		child.queue_free()
		
func clear_vbox_label():
	# Vide complètement l'inventaire
	while vbox_label.get_child_count() > 0:
		var child = vbox_label.get_child(0)
		vbox_label.remove_child(child)
		child.queue_free()
