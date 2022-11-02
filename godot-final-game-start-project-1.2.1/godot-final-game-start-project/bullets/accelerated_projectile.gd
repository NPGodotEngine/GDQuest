extends Bullet

export var max_speed := 10000
export var acc_factor : = 0.5
onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	animation_player.play("spawn")

# add acceleration 	
func _move(delta: float) -> void:
	speed = lerp(speed, max_speed, delta * acc_factor)
	._move(delta)
	
func _destroy() -> void:
	_disable()
	_audio.play()
	animation_player.play("destroy")
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "destroy":
		queue_free()
