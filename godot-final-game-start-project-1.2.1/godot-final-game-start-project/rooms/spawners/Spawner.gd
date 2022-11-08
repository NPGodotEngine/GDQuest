class_name Spawner
extends Sprite

export (Array, PackedScene) var list := []
export (int, 0, 100) var spawn_chance_percent := 50

func _ready() -> void:
	texture = null
	randomize()

func spawn() -> void:
	if not list:
		return
		
	var chance = randi() % 100
	if chance >= spawn_chance_percent:
		return
	
	var random_scene_index = randi() % list.size()
	var scene: PackedScene = list[random_scene_index]
	
	if not scene:
		return
	
	var node: Node2D = scene.instance()
	get_parent().add_child(node)
	node.global_position = global_position
