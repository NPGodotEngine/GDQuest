extends Node2D

onready var player_1 := $PlayerCharacter
onready var player_2 := $PlayerCharacter2

func _ready() -> void:
	player_1.settings = preload("Player_1_setting.tres")
	player_2.settings = preload("Player_2_setting.tres")
	player_1.settings.hand_texture = preload("../assets/hand_red_open.png")
