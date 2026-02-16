extends CharacterBody2D
class_name Player

@onready var interact_ui = $InteractUI

@export var speed = 400
@export var stats_class_local: stats_class_player


# Stats du personage
#var pv_max = Stats.pv_max
#var pm_max = Stats.pm_max
#var atk = Stats.atk
#var def = Stats.def
#var spd = Stats.spd
#var pierre = Stats.pierre

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
	if Input.is_action_just_pressed("debug"):
		var combat = LancerCombat.recup_infos(0)
		print(combat)
		get_tree().change_scene_to_packed(combat[0])
		
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

	var stats_list = ["pv_max", "pm_max", "atk", "def", "spd", "pierre"]
	for stat_actuelle in stats_list:
		stats_class_local.set(stat_actuelle, stats_class_local.get(stat_actuelle) + randi() % 4 + 2)
