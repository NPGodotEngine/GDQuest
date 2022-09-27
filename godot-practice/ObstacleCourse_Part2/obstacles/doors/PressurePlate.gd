tool
extends Area2D

## The duration the linked door stay open in seconds
export (float, 0.0, 100.0) var open_time := 1.0

onready var timer := $Timer
onready var line := $Line2D
onready var door := $Door
onready var anim_player := $AnimationPlayer
onready var door_anim_player := $Door/AnimationPlayer

func _get_configuration_warning() -> String:
	var door_node := get_node_or_null("Door") as StaticBody2D
	if not door_node:
		return "This node needs a child node named Door, either an instance of DoorHorizontal or DoorVertical."
	return ""	

func _ready() -> void:
	timer.wait_time = open_time
	
	line.points = [
		Vector2.ZERO,
		Vector2(door.position.x, 0.0),
		door.position,
	]
	
	connect("area_entered", self, "_on_Area2D_area_body_entered")
	timer.connect("timeout", self, "_on_Timer_timeout")
	
func _on_Area2D_area_body_entered(body:Node) -> void:
	anim_player.play("open")
	door_anim_player.play("open")
	timer.start()

func _on_Timer_timeout() -> void:
	anim_player.play("closed")
	door_anim_player.play("closed")
