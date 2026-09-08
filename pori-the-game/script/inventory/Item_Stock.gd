extends Control
class_name InventoryUI

@onready var vbox_objet = $VBoxContainer
@onready var vbox_equipement = $VBoxContainer3
@onready var vbox_cle = $VBoxContainer4
@onready var vbox_label = $VBoxContainer2
@onready var vbox_info = $VBoxContainer5
var item_select



func _ready():
	# Reçois le signal permettant de mettre à jour l'inventaire
	Inventory.inventory_updated.connect(_on_inventory_updated)
	_on_inventory_updated()
	$Button.visible = false
	$Button.pressed.connect(_button_pressed)
	$Button2.pressed.connect(_button2_pressed)
	$Button3.pressed.connect(_button3_pressed)
	$Button4.pressed.connect(_button4_pressed)
	
func _physics_process(_delta):
	$AnimatedSprite2D.play("Tonar_anim_inv")
	
func _input(event):
	if event.is_action_pressed("close_inventory"):
		clear_vbox_label(vbox_label)
		clear_vbox_label(vbox_info)
		get_tree().paused = false
		$"..".visible = false

func _on_inventory_updated():
		# Vide l'inventaire pour rajouter les items en plus avec leur icone et leur nom
		clear_vbox_container(vbox_objet)
		clear_vbox_container(vbox_equipement)
		clear_vbox_container(vbox_cle)
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
				
		# Objets clés
		for item in Inventory.inventory_cle:
			if item == null:
				continue
				
			if item["type"] == "Cle":
				ajout_objet(item, vbox_cle)
		

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
	button.focus_entered.connect(item_focus.bind(item))
	button.focus_exited.connect(item_unfocus)
	hbox.add_child(button)

func item_focus(item):
	clear_vbox_label(vbox_info)
	if item["type"] == "Consomable" or item["type"] == "Cle":
		popup_invent("", item["effect"])
	elif item["type"] == "Equipement":
		popup_invent("", item["stat"])
	
func item_unfocus():
	clear_vbox_label(vbox_info)

func select_item(item):
	print("le bouton est appuyé")
	if item["type"] == "Cle":
		clear_vbox_label(vbox_info)
		popup_invent("", item["effect"])
		return
	$Button.visible = true
	$Button.grab_focus()
	item_focus(item)
	item_select = item
	
func _button_pressed():
	print("Avant PV:", global_var.Tonar_stats.pv)
	print("Avant PM:", global_var.Tonar_stats.pm)
	if item_select["type"] == "Consomable":
		clear_vbox_label(vbox_label)
		popup_invent("Vous avez consommé l'item !", "")
		clear_vbox_label(vbox_info)
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
			clear_vbox_label(vbox_label)
			popup_invent("L'équipement a été équipé !", "")
			clear_vbox_label(vbox_info)
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
			$Button.visible = false
			$Button3.call_deferred("grab_focus")
		else:
			clear_vbox_label(vbox_label)
			popup_invent("L'équipement a été retiré !", "")
			clear_vbox_label(vbox_info)
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
			$Button.visible = false
			$Button3.call_deferred("grab_focus")
			
	
func _button2_pressed():
	clear_vbox_label(vbox_info)
	clear_vbox_label(vbox_label)
	$VBoxContainer.visible = true
	$VBoxContainer4.visible = false
	$VBoxContainer3.visible = false
	
func _button3_pressed():
	clear_vbox_label(vbox_info)
	clear_vbox_label(vbox_label)
	$VBoxContainer.visible = false
	$VBoxContainer4.visible = false
	$VBoxContainer3.visible = true
	
func _button4_pressed():
	clear_vbox_label(vbox_info)
	clear_vbox_label(vbox_label)
	$VBoxContainer.visible = false
	$VBoxContainer3.visible = false
	$VBoxContainer4.visible = true
	
func popup_invent(action, information):
	if action != "":
		var act = Label.new()
		act.text = action
		vbox_label.add_child(act)

	if information != "":
		var info = Label.new()
		info.text = information
		info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox_info.add_child(info)
	
func clear_vbox_container(vbox):
	# Vide complètement l'inventaire
	while vbox.get_child_count() > 0:
		var child = vbox.get_child(0)
		vbox.remove_child(child)
		child.queue_free()
		
func clear_vbox_label(label):
	# Vide complètement les pop up soit d'information soit d'action
	while label.get_child_count() > 0:
		var child = label.get_child(0)
		label.remove_child(child)
		child.queue_free()
