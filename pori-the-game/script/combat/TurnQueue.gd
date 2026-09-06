extends Node
class_name TurnQueue

# ====== VARIABLES ======
var characters = []
var active_character_index = 0
var combat_parent = null
var combat_finished = false

# ====== INIT ======
func initialize(stats_dict, nodes_dict):
	combat_parent = get_parent()
	characters = []
	combat_finished = false

	if stats_dict == null or stats_dict.is_empty():
		push_error("stats_dict vide ou null")
		return

	for name in stats_dict.keys():
		var stats = stats_dict[name]
		if typeof(stats) != TYPE_ARRAY or stats.size() < 6:
			push_error("Stats invalides pour ", name)
			continue
		var node = nodes_dict.get(name, null) if nodes_dict else null
		characters.append({
			"name": name,
			"stats": stats,
			"node": node,
			"hp": stats[0],
			"pm": stats[1]
		})

	characters.sort_custom(func(a, b): return a["stats"][4] > b["stats"][4])
	active_character_index = 0
	print("TurnQueue initialisé : ", characters.size(), " personnages")
	for c in characters:
		print("  ", c["name"], " PV:", c["hp"], " SPD:", c["stats"][4])

# ====== TOUR PRINCIPAL ======
func play_turn():
	if combat_finished:
		return
	if characters.is_empty():
		print("Aucun personnage")
		return

	if active_character_index < 0 or active_character_index >= characters.size():
		active_character_index = 0

	var current = characters[active_character_index]
	if current == null:
		push_error("Personnage actif null")
		advance_turn()
		return

	if current.get("hp", 0) <= 0:
		advance_turn()
		return

	print("Tour de : ", current["name"])

	if current["name"] == "Tonar":
		await play_player_turn(current)
	else:
		await play_enemy_turn(current)

	# Après l'action, vérifier les morts
	await check_deaths()

	# Si le combat n'est pas terminé, passer au suivant
	if not combat_finished:
		advance_turn()

# ====== AVANCER ======
func advance_turn():
	if combat_finished:
		return

	var start_index = active_character_index
	for i in range(characters.size()):
		var idx = (start_index + 1 + i) % characters.size()
		var char = characters[idx]
		if char != null and char.get("hp", 0) > 0:
			active_character_index = idx
			play_turn()
			return

	print("Aucun personnage vivant trouvé")
	end_combat("Égalité ?")

# ====== TOUR JOUEUR ======
func play_player_turn(current):
	if combat_parent == null or not combat_parent.has_method("show_player_turn"):
		push_error("combat_parent invalide")
		return

	combat_parent.show_player_turn()
	var action = await combat_parent.player_action_selected
	combat_parent.hide_player_turn()

	match action:
		"attack": await execute_attack(current)
		"special": await execute_special(current)
		"health": await execute_health(current)
		"run": await execute_run(current)
		_: print("Action inconnue")

# ====== ACTIONS ======
func execute_attack(attacker):
	var target = get_first_enemy_alive()
	if target == null:
		display_message("Aucun ennemi vivant !")
		return
	var damage = calculate_damage(attacker, target)
	target["hp"] = max(target.get("hp", 0) - damage, 0)
	display_message("%s inflige %d dégâts à %s" % [attacker["name"], damage, target["name"]])
	show_damage_popup(target, damage, false)
	await get_tree().create_timer(0.5).timeout

func execute_special(attacker):
	var cost = 10
	if attacker.get("pm", 0) < cost:
		display_message("Pas assez de PM !")
		await get_tree().create_timer(0.5).timeout
		return
	attacker["pm"] = attacker.get("pm", 0) - cost

	# Synchroniser les stats de Tonar avec global_var et mettre à jour l'UI
	sync_tonar_stats()

	var enemies = get_all_enemies_alive()
	if enemies.is_empty():
		display_message("Aucun ennemi vivant !")
		return

	var total_damage = 0
	for hit in range(3):
		for enemy in enemies:
			if randf() < 0.1:
				display_message("%s rate %s !" % [attacker["name"], enemy.get("name", "?")])
				await get_tree().create_timer(0.3).timeout
				continue
			var damage = int((attacker["stats"][2] * 4 - enemy["stats"][3] * 2) / 2)
			if damage < 1: damage = 1
			enemy["hp"] = max(enemy.get("hp", 0) - damage, 0)
			total_damage += damage
			display_message("%s inflige %d dégâts à %s (coup %d)" % [attacker["name"], damage, enemy.get("name", "?"), hit+1])
			show_damage_popup(enemy, damage, false)
			await get_tree().create_timer(0.3).timeout
	display_message("Floor is Lava ! Total : %d" % total_damage)
	await get_tree().create_timer(0.5).timeout

func execute_health(attacker):
	var heal_amount = 20
	var max_hp = attacker["stats"][0]
	var old = attacker.get("hp", 0)
	attacker["hp"] = min(old + heal_amount, max_hp)

	# Synchroniser les stats de Tonar avec global_var et mettre à jour l'UI
	sync_tonar_stats()

	display_message("%s se soigne de %d PV" % [attacker["name"], attacker["hp"] - old])
	await get_tree().create_timer(0.5).timeout

func execute_run(attacker):
	var enemies = get_all_enemies_alive()
	if enemies.is_empty():
		display_message("Plus d'ennemis !")
		await get_tree().create_timer(0.5).timeout
		return

	var tonar_speed = attacker["stats"][4]
	var total_enemy_speed = 0
	for e in enemies:
		total_enemy_speed += e["stats"][4]
	var chance = 0.5 * tonar_speed / (total_enemy_speed if total_enemy_speed > 0 else 1)
	chance = clamp(chance, 0.1, 0.9)

	if randf() < chance:
		display_message("Fuite réussie !")
		await get_tree().create_timer(0.5).timeout
		end_combat("Fuite")
	else:
		display_message("Fuite échouée !")
		await get_tree().create_timer(0.5).timeout

# ====== TOUR ENNEMI ======
func play_enemy_turn(current):
	var target = get_character_by_name("Tonar")
	if target == null or target.get("hp", 0) <= 0:
		return
	var damage = calculate_damage(current, target)
	target["hp"] = max(target.get("hp", 0) - damage, 0)

	# Synchroniser les stats de Tonar avec global_var et mettre à jour l'UI
	sync_tonar_stats()

	display_message("%s inflige %d dégâts à Tonar" % [current["name"], damage])
	show_damage_popup(target, damage, true)

	await get_tree().create_timer(0.5).timeout

# ====== FONCTIONS UTILES ======
func calculate_damage(attacker, defender):
	if attacker == null or defender == null: return 0
	var atk = attacker["stats"][2]
	var def = defender["stats"][3]
	var damage = atk * 4 - def * 2
	if damage < 1: damage = 1
	return damage

func get_first_enemy_alive():
	for char in characters:
		if char != null and char.get("name") != "Tonar" and char.get("hp", 0) > 0:
			return char
	return null

func get_all_enemies_alive():
	var enemies = []
	for char in characters:
		if char != null and char.get("name") != "Tonar" and char.get("hp", 0) > 0:
			enemies.append(char)
	return enemies

func get_character_by_name(name):
	for char in characters:
		if char != null and char.get("name") == name:
			return char
	return null

func display_message(text):
	if combat_parent != null and combat_parent.has_method("set_message"):
		combat_parent.set_message(text)
	else:
		print("MSG : ", text)

# ====== AFFICHAGE DES DÉGÂTS VISUELS ======
func show_damage_popup(target, damage: int, is_player: bool = false):
	var target_node = null
	if target.get("node") != null and target["node"] != null:
		target_node = target["node"]
	elif target.get("name") == "Tonar":
		# Pour Tonar, on affiche au centre de l'écran ou à côté des barres
		target_node = combat_parent.get_node("HUD") if combat_parent and combat_parent.has_node("HUD") else null
		if target_node == null:
			print("Aucun nœud trouvé pour afficher les dégâts sur Tonar")
			return

	if target_node == null:
		print("Aucun nœud trouvé pour afficher les dégâts sur ", target.get("name"))
		return

	var popup_scene = preload("res://scenes/HUD/damage_popub.tscn")
	if popup_scene == null:
		push_error("DamagePopup.tscn introuvable !")
		return

	var popup = popup_scene.instantiate()
	# Calculer une position : pour Tonar, on met à côté des barres, pour les ennemis, sur eux
	if target.get("name") == "Tonar":
		# Positionner à côté des barres (par exemple en haut à gauche)
		popup.global_position = Vector2(100, 50)  # ajustez selon votre UI
	else:
		popup.global_position = target_node.global_position + Vector2(randi_range(-30, 30), -20)

	get_tree().current_scene.add_child(popup)
	popup.setup(damage, is_player)

# ====== VÉRIFICATION DES MORTS ======
func check_deaths():
	# Supprimer les ennemis morts
	for char in characters:
		if char == null: continue
		if char.get("name") != "Tonar" and char.get("hp", 0) <= 0:
			display_message(char.get("name", "Inconnu") + " est vaincu !")
			if char.get("node") != null:
				char["node"].queue_free()
			await get_tree().create_timer(0.5).timeout

	# Vérifier Tonar
	var tonar = get_character_by_name("Tonar")
	if tonar == null:
		push_error("Tonar introuvable")
		return
	if tonar.get("hp", 0) <= 0:
		end_combat("Défaite")
		return

	# Vérifier victoire
	var enemies = get_all_enemies_alive()
	if enemies.is_empty():
		end_combat("Victoire")

# ====== SYNCHRONISATION DES STATS DE TONAR ======
func sync_tonar_stats():
	# Récupération du personnage Tonar
	var tonar = get_character_by_name("Tonar")
	if tonar == null:
		return

	# Vérification que c'est bien un dictionnaire et qu'il possède les clés nécessaires
	if not tonar is Dictionary:
		return
	if not tonar.has("hp") or not tonar.has("pm"):
		return

	# Récupération sécurisée des valeurs
	var hp = tonar.get("hp", 0)
	var pm = tonar.get("pm", 0)

	# Mise à jour de global_var.Tonar_stats si disponible
	if global_var != null and global_var.Tonar_stats != null:
		global_var.Tonar_stats.pv = hp
		global_var.Tonar_stats.pm = pm

	# Rafraîchissement de l'UI
	if combat_parent != null and combat_parent.has_method("update_bars"):
		combat_parent.update_bars()

# ====== FIN DU COMBAT ======
func end_combat(reason):
	if combat_finished:
		return
	combat_finished = true
	display_message(reason + " !")
	
	# Afficher l'écran de fin
	if combat_parent != null and combat_parent.has_method("show_end_screen"):
		if reason == "Victoire":
			combat_parent.show_end_screen("VICTOIRE !", Color(0, 1, 0))
		elif reason == "Défaite":
			combat_parent.show_end_screen("DÉFAITE...", Color(1, 0, 0))
		elif reason == "Fuite":
			combat_parent.show_end_screen("FUITE RÉUSSIE", Color(1, 0.8, 0))
		else:
			combat_parent.show_end_screen(reason, Color.WHITE)
	
	get_tree().paused = true
