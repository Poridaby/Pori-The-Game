extends Area2D


var joueur_in_range = false
var in_interact = false
@onready var sprite = $/root/Main/panneau_lecture

func _ready():
	"""
	Initialise le panneau comme masqué
	:comportement: masque le panneau directement
	"""
	sprite.visible = false


func _process(_delta):
	"""
	Gère l'affichage du panneau
	:param _delta: a laisser, jamais utilisé mais obligatoire pour que la fonction soit reconnue
	:comportement affiche le panneau au bon moment
	"""
	# Affiche le panneau quand l'utilisateur interagit dans la portée
	if overlaps_body($/root/Main/Joueur_P) and Input.is_action_just_pressed("interact") and not in_interact:
		sprite.visible = true
		global_var.player_can_move = false
		await get_tree().create_timer(0.5).timeout
		in_interact = true
	# Masque le paneau quand l'utilisateur est trop loin
	if Input.is_action_just_pressed("interact") and in_interact:
		sprite.visible = false
		global_var.player_can_move = true
		in_interact = false
