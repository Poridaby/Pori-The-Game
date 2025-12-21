extends CharacterBody2D


@export var speed = 400

var stats = {
	"XP":0,
	"PV":10,
	"PM":10,
	"ATK":10,
	"DEF":10,
	"PIERRE":10,
	}

func _ready():
	load_stats()

func _exit_tree():
	save_stats()

func _physics_process(_delta):
	"""
	Assigne les touches de déplacement
	:param _delta: a laisser, jamais utilisé mais obligatoire pour que la fonction soit reconnue
	:comportement: déplacement du personnage lors de l'utilisation des touches
	"""
	# Assigne 1 velocité par touches
	var vel = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if Input.is_action_pressed("move_down"):
		vel.y += 1


	if global_var.player_can_move == true:
	#Endroit qui permet de déclencher ou non l'animation
		if vel.length() > 0:
			vel = vel.normalized() * speed
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
		velocity = vel
		# move_and_slide() gère automatiquement les collisions
		# et empêche le personnage de traverser un StaticBody2D
		move_and_slide()

		# Si déplacement horizontal
		if vel.x != 0:
			$AnimatedSprite2D.animation = "marche"
			# Retourne le sprite si on va à gauche
			$AnimatedSprite2D.flip_h = vel.x < 0  
		# Sinon si déplacement vertical  
		elif vel.y != 0:                    
			$AnimatedSprite2D.animation = "haut"

	else:
		$AnimatedSprite2D.stop()

# Système de sauvegarde
func load_stats():
	if not FileAccess.file_exists("user://player_stats.json"):
		return

	var file := FileAccess.open("user://player_stats.json", FileAccess.READ)
	var content := file.get_as_text()
	file.close()

	var data = JSON.parse_string(content)
	if typeof(data) == TYPE_DICTIONARY:
		stats = data


func save_stats():
	var file := FileAccess.open("user://player_stats.json", FileAccess.WRITE)
	if file == null:
		return

	var json_string := JSON.stringify(stats)
	file.store_string(json_string)
	file.close()

#Système d'xp
func lvl_up():
	pass
