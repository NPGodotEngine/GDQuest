extends "Turret.gd"


# Extend the appropriate function here.
func _on_Timer_timeout():
	if not target:
		return
		
	var rocket: Area2D = preload("HomingRocket.tscn").instance()
	add_child(rocket)
	rocket.global_transform = cannon.global_transform
	rocket.target = target
	rocket.set_initial_velocity()
