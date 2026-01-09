extends Node2D

@onready var hud = $HUD
@onready var sub = $submenu
var rng := RandomNumberGenerator.new()

# Récup Tonar_stats et les stats de l'ennemid
# Récupère les stats clonées
var tonar = BattleManager.current_player
var tonar_stats = tonar.runtime_stats
var enemy_stats = BattleManager.current_enemy_stats

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
	
	if tonar == null:
		push_error("Le joueur n'a pas été instancié !")
		return
	
	
	# Assignation des sprites (exemple)
	$TonarSprite.texture = tonar_stats.battle_sprite  # tu peux utiliser un sprite propre
	$EnemySprite.texture = enemy_stats.battle_sprite  # ou enemy_stats.battle_sprite
	
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
		print("OOOUUUUFFF CA DOIT FAIRE MAL ", enemy_stats.pv)
		
func end_or_not():
	if enemy_stats.pv <= 0:
		get_tree().change_scene_to_file("res://scenes/décor_explo/Inser_ellenon.tscn")
	else:
		$submenu/pass.visible = false
		turn_enemy()
