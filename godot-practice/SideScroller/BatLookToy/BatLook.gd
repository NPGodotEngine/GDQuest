extends Sprite

# Stores the bat textures in an array for easy access.
var bat_textures := [
	preload("bat_aware.png"),
	preload("bat_hang.png")
]

onready var look_direction := $LookDirection
onready var raycast := $RayCast2D

func _physics_process(delta:float) -> void:
	raycast.look_at(get_global_mouse_position())
	raycast.force_raycast_update()
	
	if raycast.get_collider() is KinematicBody2D:
		texture = bat_textures[0]
	else:
		texture = bat_textures[1]
		
	look_direction.vector = to_local(raycast.get_collision_point())
