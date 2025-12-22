extends Node

# Décide si le joueur a le droit de bouger
var player_can_move = true

# Texte a afficher dans la boite de dialogue
var texte_dialogue = "Ereur"

# Choisi le bon point de spawn après la prise d'une warp
var next_spawn_name: String = ""

# Statistiques des joueurs:
var stats_1 = {
	"XP":10,
	"PV":10,
	"PM":10,
	"ATK":10,
	"DEF":10,
	"SPEED":10,
	"PIERRE":10,
	}
