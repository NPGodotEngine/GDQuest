extends "Pickup.gd"

func apply_effect(body:Node) -> void:
	if body.has_method("toggle_ghost_effect"):
		body.toggle_ghost_effect(true)
