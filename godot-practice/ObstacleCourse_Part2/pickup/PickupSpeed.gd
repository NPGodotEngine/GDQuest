extends "Pickup.gd"

func apply_effect(body:Node) -> void:
	if body.has_method("apply_speed_effect"):
		body.apply_speed_effect()
