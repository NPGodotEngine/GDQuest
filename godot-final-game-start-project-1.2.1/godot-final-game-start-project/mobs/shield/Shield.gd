extends Mob

onready var cannon := $Cannon
onready var line_of_sight := $RayCast2D

func _prepare_to_attack() -> void:
	if not is_ready_to_attack():
		return
	_before_attack_timer.start()
	
func _on_BeforeAttackTimer_timeout() -> void:
	if not _target:
		return
	cannon.shoot_at_target(_target)
	_cooldown_timer.start()
	
func _physics_process(delta) -> void:
	if not _target:
		return
	
	# Check if robot is in sight
	var dir_to_target = line_of_sight.global_position.direction_to(_target.global_position)
	var dist_to_target = line_of_sight.global_position.distance_to(_target.global_position)
	line_of_sight.cast_to = dir_to_target * dist_to_target
	line_of_sight.force_raycast_update()
	if not line_of_sight.get_collider() is Robot:
		return
		
	cannon.look_at(_target.global_position)
	if _target_within_range:
		orbit_target()
		_prepare_to_attack()
	else:
		follow(_target.global_position)
