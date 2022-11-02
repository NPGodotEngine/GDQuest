class_name SpellSpray
extends Spell

enum FIRE_MODES {
	auto,
	semi_auto
}

export var num_shots_per_fire := 3
export(FIRE_MODES) var fire_mode := FIRE_MODES.auto

func _physics_process(delta) -> void:
	if fire_mode == FIRE_MODES.auto:
		if Input.is_action_pressed("shoot") && _cooldown_timer.is_stopped():
			shoot()
	elif fire_mode == FIRE_MODES.semi_auto:
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
