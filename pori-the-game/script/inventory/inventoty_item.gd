@tool
extends Node2D

# Propriété des items
@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
var scene_path: String = "res://scenes/décor_explo/inventory_item.tscn"

# Réference du node de scène
@onready var icon_sprite = $Sprite2D

var player_in_range = false

func _ready():
	# Set la texture pour l'afficher in game
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta):
	# Set la texture pour l'afficher dans l'éditeur
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture

# Ajoute l'item dans l'inventaire
func pickup_item():
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"effect": item_effect,
		"scene_path": scene_path
	}
	if Inventory.player_node:
		Inventory.add_item(item)
		self.queue_free()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
