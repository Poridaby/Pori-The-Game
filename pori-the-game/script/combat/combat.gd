extends Node2D

# ====== SIGNALS ======
signal player_action_selected(action_name)

# ====== VARIABLES ======
var ennemis_a_spawn = []
var ennemi1_stats = null
var ennemi2_stats = null
var ennemi3_stats = null
var combattants = {}

# Références aux nœuds (seront initialisées dans _ready)
var turn_queue_ref = null
var attack_btn = null
var special_btn = null
var health_btn = null
var run_btn = null
var message_label = null
var hp_bar = null
var mp_bar = null
var hp_label = null
var mp_label = null
var end_screen = null
var result_label = null
var continue_button = null

# ====== READY ======
func _ready():
	# Recherche sécurisée des nœuds
	turn_queue_ref = $TurnQueue if has_node("TurnQueue") else null
	attack_btn = $HUD/attack if has_node("HUD/attack") else null
	special_btn = $HUD/special if has_node("HUD/special") else null
	health_btn = $HUD/health if has_node("HUD/health") else null
	run_btn = $HUD/run if has_node("HUD/run") else null
	message_label = $HUD/message_label if has_node("HUD/message_label") else null
	hp_bar = $HUD/HPBar if has_node("HUD/HPBar") else null
	mp_bar = $HUD/MPBar if has_node("HUD/MPBar") else null
	hp_label = $HUD/HPLabel if has_node("HUD/HPLabel") else null
	mp_label = $HUD/MPLabel if has_node("HUD/MPLabel") else null
	end_screen = $EndScreen if has_node("EndScreen") else null
	if end_screen:
		result_label = $EndScreen/ResultLabel if $EndScreen.has_node("ResultLabel") else null
		continue_button = $EndScreen/ContinueButton if $EndScreen.has_node("ContinueButton") else null
		end_screen.visible = false  # caché au départ

	if turn_queue_ref == null:
		push_error("TurnQueue introuvable !")

	# Connexion des boutons
	if attack_btn: attack_btn.pressed.connect(_on_attack_pressed)
	if special_btn: special_btn.pressed.connect(_on_special_pressed)
	if health_btn: health_btn.pressed.connect(_on_health_pressed)
	if run_btn: run_btn.pressed.connect(_on_run_pressed)

	hide_player_turn()
	
	# Mettre à jour les barres au départ
	update_bars()

# ====== BOUTONS ======
func _on_attack_pressed(): player_action_selected.emit("attack")
func _on_special_pressed(): player_action_selected.emit("special")
func _on_health_pressed(): player_action_selected.emit("health")
func _on_run_pressed(): player_action_selected.emit("run")

# ====== SETUP (appelé par lancer_combat) ======
func setup_combat(liste_ennemis):
	ennemis_a_spawn = liste_ennemis
	call_deferred("start_combat")

# ====== LANCEMENT ======
func start_combat():
	if turn_queue_ref == null:
		push_error("TurnQueue introuvable, combat impossible")
		return

	spawn_ennemis()

	var dict = {}
	if ennemi1_stats != null: dict["Ennemi1"] = ennemi1_stats
	if ennemi2_stats != null: dict["Ennemi2"] = ennemi2_stats
	if ennemi3_stats != null: dict["Ennemi3"] = ennemi3_stats
	dict["Tonar"] = tonar()

	combattants["Tonar"] = null

	print("DEBUG dict : ", dict)
	print("DEBUG combattants : ", combattants)

	# Mettre à jour les barres
	update_bars()

	turn_queue_ref.initialize(dict, combattants)
	turn_queue_ref.play_turn()

# ====== SPAWN ======
func spawn_ennemis():
	var spawners = $Spawners_ennemi.get_children()
	if spawners.is_empty():
		push_error("Aucun spawner trouvé")
		return

	var stats = []
	for i in range(ennemis_a_spawn.size()):
		if i >= spawners.size(): break
		var mob_name = ennemis_a_spawn[i]
		var mob_scene = load("res://scenes/enemy_combat/" + mob_name + ".tscn")
		if mob_scene == null:
			push_error("Mob introuvable : " + mob_name)
			continue
		var mob_instance = mob_scene.instantiate()
		mob_instance.global_position = spawners[i].global_position
		var key = "Ennemi" + str(i+1)
		combattants[key] = mob_instance
		add_child(mob_instance)
		stats.append(recup_infos(mob_name))

	if stats.size() > 0: ennemi1_stats = stats[0]
	if stats.size() >= 2: ennemi2_stats = stats[1]
	if stats.size() >= 3: ennemi3_stats = stats[2]

# ====== STATS ======
func recup_infos(ennemi):
	var ennemi_possibles = {
		"ptitcrote": preload("res://script/stats/stats_ennemis/ptitcrote.tres"),
		"Carotte_maléfique": preload("res://script/stats/stats_ennemis/carotte_maléfique.tres"),
	}
	var ennemi_stats = ennemi_possibles.get(ennemi)
	if ennemi_stats == null:
		push_error("Stats non trouvées pour : " + ennemi)
		return [1, 0, 0, 0, 0, 0]
	return [ennemi_stats.pv, ennemi_stats.pm, ennemi_stats.atk, ennemi_stats.def, ennemi_stats.spd, ennemi_stats.pierre]

func tonar():
	# Utiliser les stats de global_var si elles existent
	if global_var.Tonar_stats != null:
		return [global_var.Tonar_stats.pv, global_var.Tonar_stats.pm, 
				global_var.Tonar_stats.atk, global_var.Tonar_stats.def, 
				global_var.Tonar_stats.spd, global_var.Tonar_stats.pierre]
	
	var tonar_stats = preload("res://script/stats/Tonar.tres")
	if tonar_stats == null:
		return [100, 50, 10, 5, 8, 0]
	return [tonar_stats.pv, tonar_stats.pm, tonar_stats.atk, tonar_stats.def, tonar_stats.spd, tonar_stats.pierre]

# ====== MISE À JOUR DES BARRES ======
func update_bars():
	if hp_bar == null or mp_bar == null:
		print("Barres introuvables")
		return

	# Récupérer les stats actuelles de Tonar depuis global_var
	var stats = tonar()
	var current_hp = stats[0]
	var current_pm = stats[1]
	var max_hp = current_hp  # par défaut, mais on peut les stocker
	var max_pm = current_pm

	# Si global_var a les max, les utiliser
	if global_var.Tonar_stats != null:
		max_hp = global_var.Tonar_stats.pv_max if global_var.Tonar_stats.has_method("get") and global_var.Tonar_stats.pv_max else current_hp
		max_pm = global_var.Tonar_stats.pm_max if global_var.Tonar_stats.has_method("get") and global_var.Tonar_stats.pm_max else current_pm

	hp_bar.max_value = max_hp
	hp_bar.value = current_hp
	# Couleur : vert
	hp_bar.modulate = Color(0, 1, 0)
	if hp_label:
		hp_label.text = "PV: " + str(current_hp) + "/" + str(max_hp)

	mp_bar.max_value = max_pm
	mp_bar.value = current_pm
	# Couleur : bleu
	mp_bar.modulate = Color(0, 0.5, 1)
	if mp_label:
		mp_label.text = "PM: " + str(current_pm) + "/" + str(max_pm)

# ====== MESSAGES ======
func set_message(text):
	if message_label:
		message_label.text = text
	else:
		print("MSG : ", text)

# ====== UI ======
func show_player_turn():
	if attack_btn:
		attack_btn.disabled = false
		attack_btn.grab_focus()
	if special_btn: special_btn.disabled = false
	if health_btn: health_btn.disabled = false
	if run_btn: run_btn.disabled = false

func hide_player_turn():
	if attack_btn: attack_btn.disabled = true
	if special_btn: special_btn.disabled = true
	if health_btn: health_btn.disabled = true
	if run_btn: run_btn.disabled = true

# ====== FIN DU COMBAT ======
func show_end_screen(result: String, color: Color = Color.WHITE):
	if end_screen == null:
		print("Écran de fin introuvable, résultat : ", result)
		return
	end_screen.visible = true
	if result_label:
		result_label.text = result
		result_label.add_theme_color_override("font_color", color)
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
		continue_button.grab_focus()

func _on_continue_pressed():
	# Retour à la carte (modifier le chemin selon votre scène)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/décor_explo/Inser_ellenon.tscn")
