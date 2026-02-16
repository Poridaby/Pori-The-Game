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
	# Si le joueur appuie sur "espace", alors l'item est ajouté dans l'inventaire
	if player_in_range and Input.is_action_just_pressed("interact"):
		pickup_item()

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
		
# Si le joueur est dans la zone de collision de l'item, alors il peut le prendre
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true

# Si le joueur n'est pas dans la zone de collision de l'item, alors il ne peut pas le prendre
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
