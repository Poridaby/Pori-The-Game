extends CharacterBody2D


@export var speed = 400


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

	#Endroit qui permet de déclencher ou non l'animation
	if vel.length() > 0:
		vel = vel.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	if global_var.player_can_move == true:
		velocity = vel
	else:
		velocity = Vector2(0,0)

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
