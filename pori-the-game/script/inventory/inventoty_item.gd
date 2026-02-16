@tool
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture
@export var item_effect = ""
var scene_path: String = "res://scenes/décor_explo/inventory_item.tscn"

@onready var icon_sprite = $Sprite2D

func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		
func _process(_delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
