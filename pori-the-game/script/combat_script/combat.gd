extends Node2D

@onready var hud = $HUD
@onready var sub = $submenu
var rng := RandomNumberGenerator.new()
var participants := []
var current_index := 0

# Récup Tonar_stats et les stats de l'ennemi
var tonar_stats: Stats
var enemy_stats: Stats

#Récup les attaques des combattants
var enemy_attack: Attack

func start_battle():
	# Ajoute les combattants dans une liste et choisi qui attaque au début du combat en fonction de la stat de vitesse
	participants.append($EnemySprite)
	
	var player_sprite = $player.get_children()
	for player in player_sprite:
		participants.append(player)
	
	if tonar_stats.spd > enemy_stats.spd:
		current_index = 1
		next_turn()
	elif tonar_stats.spd < enemy_stats.spd:
		current_index = 0
		next_turn()
	else:
		current_index = randi_range(0, 1)
		next_turn()

func turn_player():
	# Rend visible l'HUD et lance la fonction de sélection d'action
	hud.visible = true
	sub.visible = true
	$submenu/attack_1.visible = false
	$submenu/pass.visible = false
	hud.select_action_player()
	
func turn_enemy():
	# Rend invisible l'HUD et lance la fonction d'action de l'ennemi
	hud.visible = false
	var attack = enemy_attack
	
	attack.finished.connect(_on_action_finished, CONNECT_ONE_SHOT)
	attack.execute()

func _ready():
	rng.randomize() 
	hud.visible = false
	sub.visible = false
	
	# Charge les stats des combattants
	enemy_stats = BattleManager.enemy_runtime_stats
	tonar_stats = BattleManager.player_runtime_stats
	
	#Charge les attaques des combattants
	enemy_attack = BattleManager.enemy_runtime_attack
	
	tonar_stats.pv = tonar_stats.pv_max
	enemy_stats.pv = enemy_stats.pv_max
	
	# Assigne les sprites de combats
	$EnemySprite.texture = enemy_stats.battle_sprite
	$player/TonarSprite.texture = tonar_stats.battle_sprite

	start_battle()
	
func crit():
	var base_chance = 0.05  # 5% de base
	var scaling = 0.01      # +1% par point de stat
	var crit_chance = base_chance + tonar_stats.pierre * scaling
	crit_chance = clamp(crit_chance, 0.0, 1.0)  # pas plus de 100%
	return rng.randf() < crit_chance # déclenche la chance de critique

func damage_to_enemy(multi):
	# Calcul les dégâts subit par l'ennemi et vérifie si il est mort et si il doit subir un crit
	var dmg = (tonar_stats.atk - enemy_stats.def) * multi
	if crit():
		dmg = int(dmg * 1.5)
	enemy_stats.pv -= dmg
	if enemy_stats.pv <= 0:
		print("ENNEMI VAINCU MOTHERFUCKER")
	else:
		print("OOOUUUUFFF CA DOIT FAIRE MAL ")
		
func damage_to_player():
	#Calcul les dégâts que le joueur va subir en fonction des attaques de l'ennemi
	var dmg = (enemy_stats.atk - tonar_stats.def) * enemy_attack.multi
	tonar_stats.pv -= dmg
	if tonar_stats.pv <= 0:
		print("BAAAHHH LA MERDE IL EST MORT")
	else:
		print("Ah bah oui ça fait bobo ", tonar_stats.pv)
		
func _on_action_finished():
	# Fait subir les dégats au joueur et change de tour
	damage_to_player()
	next_turn()
	
func next_turn():
	# Permet de savoir à qui est le tour en assignant le numéro de l'index à un combattant
	if current_index >= participants.size():
		current_index = 0 # recommence le tour
	var actor = participants[current_index]
	current_index += 1
	take_turn(actor)
		
func take_turn(actor):
	# Donne le tour au combattant séléctionné
	if actor == $EnemySprite:
		turn_enemy()
	else:
		turn_player()
		
func end_or_not():
	# Vérifie si c'est la fin du combat ou pas
	if enemy_stats.pv <= 0:
		get_tree().change_scene_to_file("res://scenes/décor_explo/Inser_ellenon.tscn")
	else:
		next_turn()
