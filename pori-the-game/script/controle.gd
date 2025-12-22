extends Control

enum Turn { PLAYER, MOB }
var turn_now : Turn

var character : Character
var enemy : Enemy

func turn_player():
	if Input.is_action_pressed("action_fight"):
		$"../J1".player_attack()
	if Input.is_action_pressed("action_heal"):
		$"../J1".player_heal()
	if Input.is_action_pressed("action_run"):
		$"../J1".player_run()
		
func turn_enemy():
	pass

func _ready():
	character = Character.new()
	enemy = Enemy.new()
	
	if character.stats["SPEED"] >= enemy.stats["SPEED"]:
		turn_now = Turn.PLAYER
	else:
		turn_now = Turn.MOB

func _physics_process(_delta):
	if turn_now == Turn.PLAYER:
		turn_player()
	elif turn_now == Turn.MOB:
		turn_enemy()
