extends TileMap

## Distance from the player when the mouse stops being able to interacte
const MAXIMUM_WORK_DISTANCE := 275.0

## When using `world_to_map()` or `map_to_world()`, `TileMap` reports values from the
## top-left corner of the tile. In isometric perspective, it's the top corner
## from the middle. Since we want our entities to be in the middle of the tile,
## we must add an offset to any world position that comes from the map that is
## half the vertical height of our tiles, 25 pixels on the Y-axis here.
const POSITION_OFFSET := Vector2(0, 25)

## Temporary variable to hold the active blueprint
var _blueprint: BlueprintEntity

## The simulation's entity tracker We use its functions to know if a cell is available or it
var _tracker: EntityTracker

## The ground tile that we can check the position we're trying to put an entity down on
## to see if the mouse is over the tilemap.
var _ground: TileMap

## The player entity. We can use it to check the distance from the mouse to prevent
## the player from interacting with entities that are too far away.
var _player: KinematicBody2D

## Temporary variable to store references to entities and blueprint scenes.
## We split it in two: blueprints keyed by their names and entities keyed by their blueprints.
## See the `_ready()` function below for an example of how we map a blueprint to a scene.
## Replace the `preload()` resource paths below with the paths where you saved your scenes.
onready var Library := {
	"StirlingEngine": preload("res://Entities/Blueprints/StirlingEngineBlueprint/StirlingEngineBlueprint.tscn").instance(),
}

func _ready() -> void:
	Library[Library.StirlingEngine] = preload("res://Entities/Entities/StirlingEngineEntity/StirlingEngineEntity.tscn")	
	
func _exit_tree() -> void:
	Library.StirlingEngine.queue_free()
	
func setup(tracker:EntityTracker, ground:TileMap, player:KinematicBody2D) -> void:
	_tracker = tracker
	_ground = ground
	_player = player
	
	for child in get_children():
		if child is Entity:
			# convert child node from world position to map position
			var map_position := world_to_map(child.global_position)
			
			# add child to tracker
			_tracker.place_entity(child, map_position)

func _process(delta: float) -> void:
	var has_placeable_blueprint: bool = _blueprint and _blueprint.placeable
	if has_placeable_blueprint:
		_move_blueprint_in_world(world_to_map(get_global_mouse_position()))

func _unhandled_input(event: InputEvent) -> void:
	# get mouse position in world
	var global_mouse_position := get_global_mouse_position()
	
	# if we have blueprint and is placeable
	var has_placeable_blueprint: bool = _blueprint and _blueprint.placeable
	
	# if mouse position and player is closer enough to work
	var is_closer_to_player := (global_mouse_position.distance_to(_player.global_position) 
								< MAXIMUM_WORK_DISTANCE)
	
	# get cell position on map from mouse position
	var cellv := world_to_map(global_mouse_position)
	
	# if cell is occupied
	var is_cell_occupied := _tracker.is_cell_occupied(cellv)
	
	# if cell is a ground
	var is_on_ground := _ground.get_cellv(cellv) == 0
	
	# if placing entity happend
	if event.is_action_pressed("left_click"):
		if has_placeable_blueprint:
			if not is_cell_occupied and is_closer_to_player and is_on_ground:
				_place_entity(cellv)
	# if mouse is draging				
	elif event is InputEventMouseMotion:
		if has_placeable_blueprint:
			_move_blueprint_in_world(cellv)
	# if drop action happend
	elif event.is_action_pressed("drop") and _blueprint:
		remove_child(_blueprint)
		_blueprint = null
	# if quickbar 1 action happend
	elif event.is_action_pressed("quickbar_1"):
		if _blueprint:
			remove_child(_blueprint)
		_blueprint = Library.StirlingEngine
		add_child(_blueprint)
		_move_blueprint_in_world(cellv)
		
func _place_entity(cellv:Vector2) -> void:
	var new_entity = Library[_blueprint].instance()
	
	add_child(new_entity)
	new_entity.global_position = map_to_world(cellv) + POSITION_OFFSET
	new_entity._setup(_blueprint)
	_tracker.place_entity(new_entity, cellv)

func _move_blueprint_in_world(cellv:Vector2) -> void:
	_blueprint.global_position = map_to_world(cellv) + POSITION_OFFSET
	
	var is_closer_to_player = (_blueprint.global_position.distance_to(_player.global_position) 
								< MAXIMUM_WORK_DISTANCE)
	
	var is_on_ground := _ground.get_cellv(cellv) == 0
	var is_cell_occupied := _tracker.is_cell_occupied(cellv)
	
	if not is_cell_occupied and is_on_ground and is_closer_to_player:
		_blueprint.modulate = Color.white
	else:
		_blueprint.modulate = Color.red
