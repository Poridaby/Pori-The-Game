extends CharacterBody2D
class_name Player

@onready var color_rect = $ColorRect
@onready var inventory_visible = false
@onready var item_stock = preload("res://scenes/décor_explo/InventoryUI.tscn")
@onready var inst = item_stock.instantiate()
@onready var inventory = inst.get_node("Item_Stock")

@export var speed = 400
@export var stats_class_local: stats_class_player

@onready var animated_sprite = $AnimatedSprite2D
var last_anim_name = ""
var last_direction := Vector2.DOWN
var idle_timer := 0.0
var idle_delay := 0.1 # 100 ms

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
	add_child(inst)
	inst.visible = false
	Inventory.set_player_reference(self)
	if global_var.next_spawn_name != "":
		var spawner = get_tree().current_scene.get_node(global_var.next_spawn_name)
		global_position = spawner.global_position
		velocity = Vector2.ZERO
		global_var.next_spawn_name = ""  # reset

func _physics_process(_delta):
	"""
	Assigne les touches de déplacement
	"""
	
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Test du système de combat
	if Input.is_action_just_pressed("debug"):
		LancerCombat.combattre(0)
		
	# Ouvre l'inventaire
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = true
		inst.visible = true
		inventory.first_button.call_deferred("grab_focus")

	if global_var.player_can_move:
		if dir != Vector2.ZERO:
			idle_timer = 0.0
			# Normalise et applique la vitesse UNE FOIS
			velocity = dir.normalized() * speed
			last_direction = dir
			
			# Détermine l'animation en fonction de la direction
			var anim_name = ""
			if dir.y < 0:
				anim_name = "avance_arrière"
			elif dir.y > 0:
				anim_name = "avance_devant"
			elif dir.x < 0:
				anim_name = "avance_gauche"
			elif dir.x > 0:
				anim_name = "avance_droite"
			
			if animated_sprite.animation != anim_name:
				animated_sprite.play(anim_name)
				
		else:
			idle_timer += _delta
			velocity = Vector2.ZERO
			
			if idle_timer >= idle_delay:
				var idle_anim = ""
				if last_direction.y < 0:
					idle_anim = "idle_arrière"
				elif last_direction.y > 0:
					idle_anim = "idle_devant"
				elif last_direction.x < 0:
					idle_anim = "idle_gauche"
				elif last_direction.x > 0:
					idle_anim = "idle_droite"
			
				if animated_sprite.animation != idle_anim:
					animated_sprite.play(idle_anim)
		
	
	# move_and_slide() gère automatiquement les collisions
	move_and_slide()

	



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
