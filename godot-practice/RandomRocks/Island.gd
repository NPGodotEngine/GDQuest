extends Node2D

const rocks := [
	preload("rocks/Rock1.tscn"),
	preload("rocks/Rock2.tscn"),
	preload("rocks/Rock3.tscn"),
] 

onready var mask := $Mask


func _ready():
	randomize()
	mask.visible = false
	add_rocks_on_grid()

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		var root = get_tree().current_scene
		for n in root.get_children():
			if n is Sprite:
				root.remove_child(n)
		add_rocks_on_grid()	

func get_random_rock():
	var rock_index = randi() % rocks.size()
	return rocks[rock_index].instance()
	
func add_rocks_on_grid():
	for cell in mask.get_used_cells():
		var rock = get_random_rock()
		add_child(rock)

		var rock_size = rock.texture.get_size() * rock.scale
		var available_space = mask.cell_size - rock_size
		var random_offset = available_space * Vector2(randf(), randf())
		rock.position = mask.position + mask.map_to_world(cell) + random_offset 
