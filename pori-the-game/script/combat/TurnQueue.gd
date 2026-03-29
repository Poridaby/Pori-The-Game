extends Node

class_name TurnQueue

var active_character


func initialize(stats):
	var keys = stats.keys()
	var meilleur = keys[0]
	var liste_rdm = [meilleur]

	for key in keys:
		if stats[key][4] > stats[meilleur][4]:
			meilleur = key
			liste_rdm = [key]
		elif stats[key][4] == stats[meilleur][4]:
			if key not in liste_rdm:
				liste_rdm.append(key)

	var choix = null
	if liste_rdm.size() > 1:
		choix = liste_rdm.pick_random()
	else:
		choix = meilleur

	active_character = choix
	print(choix)
	
func play_turn():
	await active_character.play_turn()
	var new_index : int = (active_character.get_index() + 1) % get_child_count()
	active_character = get_child(new_index)
