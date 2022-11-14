extends Node2D

export var health := 100
export var max_health := 100

func take_damage(amount:int) -> void:
	health = clamp(health-amount, 0, max_health)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("sprint"):
		take_damage(1)	
		Events.emit_signal("player_health_changed", health, max_health)
