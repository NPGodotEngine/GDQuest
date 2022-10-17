extends StaticBody2D

onready var tween := $Tween
onready var initial_position := position

var is_open := false

func activate() -> void:
	is_open = not is_open
	var target_position := initial_position
	if is_open:
		target_position.y += 260.0
	
	tween.remove_all()
	tween.interpolate_property(
		self,
		"position",
		position,
		target_position,
		0.8,
		Tween.TRANS_EXPO,
		Tween.EASE_OUT,
		0.2
	)
	tween.start()
