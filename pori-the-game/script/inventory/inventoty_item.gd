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

func _ready():
	# Set la texture pour l'afficher in game
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta):
	# Set la texture pour l'afficher dans l'éditeur
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
