extends Area2D

export (float, 0.01, 1.0) var rotation_factor = 0.1
onready var timer := $Timer
onready var cannon := $Sprite/Position2D
onready var sprite := $Sprite

var target: PhysicsBody2D = null

func _ready():
	timer.connect("timeout", self, "_on_Timer_timeout")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_Timer_timeout():
	var rocket: Area2D = preload("common/Rocket.tscn").instance()
	add_child(rocket)
	rocket.global_transform = cannon.global_transform

func _on_body_entered(body:PhysicsBody2D):
	target = body

func _on_body_exited(_body:PhysicsBody2D):
	target = null
	
func _physics_process(_delta):
	var target_angle: float = PI / 2.0
	if target:
		target_angle = target.global_position.angle_to_point(global_position)
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_factor)
	
