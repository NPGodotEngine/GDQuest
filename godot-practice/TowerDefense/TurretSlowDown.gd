extends "Turret.gd"

const speed_divider = 2.0
const color: Color = Color(0.4, 0.6, 1.0)

func _ready():
	set_physics_process(false)
	
func _on_Timer_timeout():
	pass
	
func _on_body_entered(body:Node):
	._on_body_entered(body)
	body.speed /= speed_divider
	body.modulate = color

func _on_body_exited(body:Node):
	._on_body_exited(body)
	body.speed *= speed_divider
	body.modulate = Color(1.0, 1.0, 1.0)
