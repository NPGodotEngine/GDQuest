extends Mob

export (float, 100.0, 400.0) var slow_speed := 350.0

onready var animation_player := $AnimationPlayer
onready var shock_detection := $ShockArea

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimtionPlayer_finished")
	shock_detection.connect("body_entered", self, "_on_ShockArea_body_entered")

func _on_AttackArea_body_entered(body: Robot) -> void:
	._on_AttackArea_body_entered(body)
	body.speed -= slow_speed
	animation_player.play("will_explode")
	
func _on_AttackArea_body_exited(_body: Robot) -> void:
	._on_AttackArea_body_exited(_body)
	_body.speed += slow_speed
	
func _on_ShockArea_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_AnimtionPlayer_finished(anim_name:String) -> void:
	if anim_name == "will_explode":
		_disable()
		_die_sound.play()
		animation_player.play("explode")
	elif anim_name == "explode":
		queue_free()
	
