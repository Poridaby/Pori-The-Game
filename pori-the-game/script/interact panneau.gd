extends Area2D


var joueur_in_range = false
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
	if overlaps_body($/root/Main/Joueur_P) and Input.is_action_just_pressed("interact"):
		sprite.visible = true
	# Ne fais rien si le joueur est dans la portée
	elif overlaps_body($/root/Main/Joueur_P):
		pass
	# Masque le paneau quand l'utilisateur est trop loin
	else:
		sprite.visible = false
