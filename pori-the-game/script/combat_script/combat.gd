extends Node2D

@onready var hud = $HUD
@onready var sub = $submenu
var rng := RandomNumberGenerator.new()

# Récup Tonar_stats et les stats de l'ennemi
var tonar_stats: Stats
var enemy_stats: Stats

#Récup les attaques des combattants
var enemy_attack: Array[Attack]
	
func turn_player():
	# Rend visible l'HUD et lance la fonction de sélection d'action
	hud.visible = true
	sub.visible = false
	hud.select_action_player()
	
	
func turn_enemy():
	# Rend invisible l'HUD et lance la fonction d'action de l'ennemi
	hud.visible = false
	hud.select_action_enemy()

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
	$TonarSprite.texture = tonar_stats.battle_sprite
	
	if tonar_stats.spd > enemy_stats.spd:
		turn_player()
	elif tonar_stats.spd < enemy_stats.spd:
		turn_enemy()
	else:
		var turns = [
			Callable(self, "turn_player"),
			Callable(self, "turn_enemy")
		]
		turns.pick_random().call()

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
		
func damage_to_player(multi):
	#Calcul les dégâts que le joueur va subir en fonction des attaques de l'ennemi
	var dmg = (enemy_stats.atk - tonar_stats.def) * enemy_attack.multi
	tonar_stats.pv -= dmg
	if tonar_stats.pv <= 0:
		print("BAAAHHH LA MERDE IL EST MORT")
	else:
		print("Ah bah oui ça fait bobo")
		
func end_or_not():
	if enemy_stats.pv <= 0:
		get_tree().change_scene_to_file("res://scenes/décor_explo/Inser_ellenon.tscn")
	else:
		$submenu/pass.visible = false
		turn_enemy()
