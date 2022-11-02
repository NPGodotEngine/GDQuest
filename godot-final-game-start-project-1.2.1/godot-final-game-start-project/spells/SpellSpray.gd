class_name SpellSpray
extends Spell

export var num_shots_per_fire := 3

func _physics_process(delta) -> void:
	if Input.is_action_just_pressed("shoot") && _cooldown_timer.is_stopped():
		shoot()
		 
func shoot() -> void:
	_cooldown_timer.start()
	
	for _i in num_shots_per_fire:
		var bullet: Bullet = bullet_scene.instance()
		get_tree().root.add_child(bullet)
		bullet.global_transform = global_transform
		bullet.randomize_rotation(deg2rad(random_angle_degrees))
		bullet.speed = max_bullet_speed
		bullet.max_range = max_range
		
	_audio.play()
