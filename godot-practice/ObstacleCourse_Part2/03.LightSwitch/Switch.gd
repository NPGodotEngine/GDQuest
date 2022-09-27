tool
extends Area2D


onready var timer := $Timer
onready var light := $Light
onready var animation_player := $AnimationPlayer

func _get_configuration_warning() -> String:
	var light_node := get_node_or_null("Light") as Light2D
	if not light_node:
		return "A child node name Light is required. The instance has to be Light.tscn"
	return ""	

func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")
	# Connect the body_entered signal to the _on_body_entered() function
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: Node) -> void:
	animation_player.play("turn_on")
	# Set light.enabled to true to turn on the lights and start the timer
	# to turn off the lights after it counts down.
	light.enabled = true
	timer.start()


func _on_Timer_timeout() -> void:
	animation_player.play("turn_off")
	light.enabled = false
