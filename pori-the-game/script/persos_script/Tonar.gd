extends CharacterBody2D
class_name Player

@export var speed = 400

# Stats du personage
@export var pv_max = 10
@export var pm_max = 10
@export var atk = 2
@export var def = 1
@export var spd = 1
@export var pierre = 9

#Système de niveau
@export var level = 1

var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)


var next_spawn_name: String = ""

func _ready():
	Inventory.set_player_reference(self)
	if global_var.next_spawn_name != "":
		var spawner = get_tree().current_scene.get_node(global_var.next_spawn_name)
		global_position = spawner.global_position
		velocity = Vector2.ZERO
		global_var.next_spawn_name = ""  # reset

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



func get_required_experience(lvl):
	# Renvoie le nombre d'experience nécessaire au lvl up
	return round(pow(lvl, 1.8) + level * 4)
	
	
func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()


func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)
	
	var stats = ["pv_max", "pm_max", "atk", "def", "spd", "pierre"]
	for stat in stats:
		set(stat, get(stat) + randi() % 4 + 2)
	
