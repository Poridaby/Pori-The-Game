extends Area2D

@export var speed = 400                #Declaration des variables
var screen_size

func _ready():                                       #Fonction qui permet d'ouvrir la fenêtre
	screen_size = get_viewport_rect().size

func _process(delta):                    #Fonction qui permet d'assigner les actions des touches  
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0:                         #Endroit qui permet de déclencher ou non l'animation
		velocity = velocity.normalized() * speed;
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:                                    #permet de changer d'animation en fonction de si le perso se déplace en vertical ou en horizontal
		$AnimatedSprite2D.animation = "marche"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "haut"
