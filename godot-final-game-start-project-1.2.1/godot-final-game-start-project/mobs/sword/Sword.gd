extends Mob

var attack_position = null
var preparing = false

onready var hitbox := $HitBox

func _ready():
	hitbox.connect("body_entered", self, "_on_HitBox_body_entered")
			
func _prepare_to_attack() -> void:
	if not is_ready_to_attack():
		return
	attack_position = _target.global_position
	preparing = true
	_before_attack_timer.start()
	_animation_player.play("prepare_attack")
	
func _enable_attack() -> void:
	if attack_position and preparing == false:
		hitbox.set_deferred("monitoring", true)
		hitbox.rotation = (attack_position - global_position).angle()
	else:
		_disable_attack()

func _disable_attack() -> void:
	hitbox.set_deferred("monitoring", false)
	attack_position = null
	preparing = false
	_animation_player.play("hover")
		
func _on_HitBox_body_entered(body: Node) -> void:
	print(body)
	if body and body.has_method("take_damage"):
		body.take_damage(damage)
	_disable_attack()

func _on_BeforeAttackTimer_timeout() -> void:
	._on_BeforeAttackTimer_timeout()
	_cooldown_timer.start()
	preparing = false
	_enable_attack()

func _physics_process(_delta) -> void:
	
	# only prepare attack when target in range and no attack position
	if _target_within_range and attack_position == null:
		_prepare_to_attack()
		
	if attack_position and preparing == false:
		# fly to attack position
		follow(attack_position)
		# stop attack when reach position
		if (attack_position - global_position).length() <= 1.0:
			_disable_attack()
	elif _target and preparing == false:
		# look at target	
		var look_at_rotation = (_target.global_position - global_position).angle()
		_sprite.rotation = look_at_rotation
	

