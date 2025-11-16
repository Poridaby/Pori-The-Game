extends CharacterBody2D

@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size


func _physics_process(_delta):                     #Fonction qui permet d'assigner les actions des touches
	var vel = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if Input.is_action_pressed("move_down"):
		vel.y += 1


	if vel.length() > 0:                           #Endroit qui permet de déclencher ou non l'animation
		vel = vel.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	velocity = vel

	# move_and_slide() gère automatiquement les collisions
	# et empêche le personnage de traverser un StaticBody2D
	move_and_slide()

	if vel.x != 0:                      # Si déplacement horizontal
		$AnimatedSprite2D.animation = "marche"
		$AnimatedSprite2D.flip_h = vel.x < 0    # Retourne le sprite si on va à gauche
	elif vel.y != 0:                    # Si déplacement vertical
		$AnimatedSprite2D.animation = "haut"
