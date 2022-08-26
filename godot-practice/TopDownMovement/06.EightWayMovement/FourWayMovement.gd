extends Node2D


const SPEED := 700
const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

onready var player: KinematicBody2D = $Godot
onready var player_sprite: Sprite = $Godot/Sprite


func _physics_process(_delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x = 1.0
	elif Input.is_action_pressed("move_left"):
		direction.x = -1.0
	elif Input.is_action_pressed("move_up"):
		direction.y = -1.0
	elif Input.is_action_pressed("move_down"):
		direction.y = 1.0
		
	player.move_and_slide(SPEED * direction)

	var direction_key := direction.round()
	# Complete the next lines
	direction_key.x = abs(direction_key.x)
	if direction_key in DIRECTION_TO_FRAME:
		player_sprite.frame = DIRECTION_TO_FRAME[direction_key]
		player_sprite.flip_h = sign(direction.x) == -1
