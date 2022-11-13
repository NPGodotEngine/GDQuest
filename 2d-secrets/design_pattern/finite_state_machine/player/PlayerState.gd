class_name PlayerState
extends State

var player: Player = null

func _ready() -> void:
	yield(owner, "ready")
	player = owner as Player

