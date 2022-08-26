extends Node2D

const rocks := [
	preload("rocks/Rock1.tscn"),
	preload("rocks/Rock2.tscn"),
	preload("rocks/Rock3.tscn"),
] 

const cell_size := Vector2(128, 128)

func _ready():
	randomize()
	add_rock_on_grid(10, 5)

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		var root = get_tree().current_scene
		for n in root.get_children():
			root.remove_child(n)
		add_rock_on_grid(10, 5)	

func get_random_rock():
	var rock_index = randi() % rocks.size()
	return rocks[rock_index].instance()

func add_rock_on_grid(columns:int, rows:int):
	for column in range(columns):
		for row in range(rows):
			var new_rock = get_random_rock()
			add_child(new_rock)
			
			var cell := Vector2(column, row)
			new_rock.position = cell_size * cell
