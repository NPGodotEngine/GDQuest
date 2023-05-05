extends TileMap

## Distance from the player when the mouse stops being able to interacte
const MAXIMUM_WORK_DISTANCE := 275.0

## Duration for deconstruction of an entity
const DECONSTRUCTION_TIME := 3.0

## When using `world_to_map()` or `map_to_world()`, `TileMap` reports values from the
## top-left corner of the tile. In isometric perspective, it's the top corner
## from the middle. Since we want our entities to be in the middle of the tile,
## we must add an offset to any world position that comes from the map that is
## half the vertical height of our tiles, 25 pixels on the Y-axis here.
const POSITION_OFFSET := Vector2(0, 25)

## The ground item packed scene we instance when dropping items
var GroundItemScene := preload("res://Entities/GroundItem.tscn")

## The simulation's entity tracker We use its functions to know if a cell is available or it
var _tracker: EntityTracker

## The ground tile that we can check the position we're trying to put an entity down on
## to see if the mouse is over the tilemap.
var _ground: TileMap

var _flat_entities: YSort

## The player entity. We can use it to check the distance from the mouse to prevent
## the player from interacting with entities that are too far away.
var _player: KinematicBody2D

## The variable below keeps track of the current deconstruction target cell. If the mouse moves
## to another cell, we can abort the operation by checking against this value.
var _current_deconstruction_location := Vector2.ZERO

## Reference to GUI node
var _gui: Control

# Deconstruction timer
onready var _deconstruction_timer := $Timer
	
func setup(gui:Control, tracker:EntityTracker, ground:TileMap, flat_entities:YSort, player:KinematicBody2D) -> void:
	_gui = gui
	_tracker = tracker
	_ground = ground
	_flat_entities = flat_entities
	_player = player
	
	for child in get_children():
		if child is Entity:
			# convert child node from world position to map position
			var map_position := world_to_map(child.global_position)
			
			# fix position for pre-placed
			child.global_position = map_to_world(map_position) + POSITION_OFFSET
			
			# add child to tracker
			_tracker.place_entity(child, map_position)

func _process(delta: float) -> void:
	var has_placeable_blueprint: bool = _gui.blueprint and _gui.blueprint.placeable
	if has_placeable_blueprint and not _gui.mouse_in_gui:
		_move_blueprint_in_world(world_to_map(get_global_mouse_position()))

func _unhandled_input(event: InputEvent) -> void:
	# get mouse position in world
	var global_mouse_position := get_global_mouse_position()
	
	# if we have blueprint and is placeable
	var has_placeable_blueprint: bool = _gui.blueprint and _gui.blueprint.placeable
	
	# if mouse position and player is closer enough to work
	var is_closer_to_player := (global_mouse_position.distance_to(_player.global_position) 
								< MAXIMUM_WORK_DISTANCE)
	
	# get cell position on map from mouse position
	var cellv := world_to_map(global_mouse_position)
	
	# if cell is occupied
	var is_cell_occupied := _tracker.is_cell_occupied(cellv)
	
	# if cell is a ground
	var is_on_ground := _ground.get_cellv(cellv) == 0
	
	if event.is_action_released("right_click"):
		_abort_deconstruct()
	
	if event is InputEventMouseButton:
		_abort_deconstruct()
	
	# if placing entity happend
	if event.is_action_pressed("left_click"):
		if has_placeable_blueprint:
			if not is_cell_occupied and is_closer_to_player and is_on_ground:
				_place_entity(cellv)
				_update_neighboring_flat_entities(cellv)
	elif event.is_action_pressed("right_click") and not has_placeable_blueprint:
		if is_cell_occupied and is_closer_to_player:
			_deconstruct(global_mouse_position, cellv)
	# if mouse is draging				
	elif event is InputEventMouseMotion:
		if cellv != _current_deconstruction_location:
			_abort_deconstruct()
		if has_placeable_blueprint:
			_move_blueprint_in_world(cellv)
	# if drop action happend
	elif event.is_action_pressed("drop") and _gui.blueprint:
		if is_on_ground:
			_drop_entity(_gui.blueprint, global_mouse_position)
			_gui.blueprint = null
	elif event.is_action_pressed("rotate_blueprint") and _gui.blueprint:
		_gui.blueprint.rotate_blueprint()


## Creates a new ground item with the given blueprint and sets it up at the
## deconstructed entity's location.
func _drop_entity(entity: BlueprintEntity, location: Vector2) -> void:
    # We instance a new ground item, add it, and set it up
    var ground_item := GroundItemScene.instance()
    add_child(ground_item)
    ground_item.setup(entity, location)

func _deconstruct(event_position:Vector2, cellv:Vector2) -> void:
	_deconstruction_timer.connect("timeout", self, "_on_finish_deconstruct", [cellv], CONNECT_ONESHOT)
	_deconstruction_timer.start(DECONSTRUCTION_TIME)
	_current_deconstruction_location = cellv

func _on_finish_deconstruct(cellv:Vector2) -> void:
	var entity := _tracker.get_entity_at(cellv)

	var entity_name := Library.get_entity_name_from(entity)
	var location := map_to_world(cellv)

	if Library.blueprints.has(entity_name):
		var Blueprint: PackedScene = Library.blueprints[entity_name]

		_drop_entity(Blueprint.instance(), location)

	_tracker.remove_entity(cellv)
	_update_neighboring_flat_entities(cellv)
	
func _abort_deconstruct() -> void:
	if _deconstruction_timer.is_connected("timeout", self, "_on_finish_deconstruct"):
		_deconstruction_timer.disconnect("timeout", self, "_on_finish_deconstruct")
	_deconstruction_timer.stop()
			
func _place_entity(cellv:Vector2) -> void:
	var entity_name = Library.get_entity_name_from(_gui.blueprint)
	var new_entity: Node2D = Library.entities[entity_name].instance()
	
	if new_entity is WireEntity:
		var direction := _get_powered_neighbors(cellv)
		_flat_entities.add_child(new_entity)
		WireBlueprint.set_sprite_for_direction(new_entity.sprite, direction)
	else:
		add_child(new_entity)
	new_entity.global_position = map_to_world(cellv) + POSITION_OFFSET
	new_entity._setup(_gui.blueprint)
	_tracker.place_entity(new_entity, cellv)

	if _gui.blueprint.stack_count == 1:
		_gui.destroy_blueprint()
	else:
		_gui.blueprint.stack_count -= 1
		_gui.update_label()

func _move_blueprint_in_world(cellv:Vector2) -> void:
	_gui.blueprint.display_as_world_entity()

	_gui.blueprint.global_position = get_viewport_transform().xform(
        map_to_world(cellv) + POSITION_OFFSET
    )
	
	var is_closer_to_player = (_gui.blueprint.global_position.distance_to(_player.global_position) 
								< MAXIMUM_WORK_DISTANCE)
	
	var is_on_ground := _ground.get_cellv(cellv) == 0
	var is_cell_occupied := _tracker.is_cell_occupied(cellv)
	
	if not is_cell_occupied and is_on_ground and is_closer_to_player:
		_gui.blueprint.modulate = Color.white
		if _gui.blueprint is WireBlueprint:
			WireBlueprint.set_sprite_for_direction(_gui.blueprint.sprite, 
				_get_powered_neighbors(cellv))
	else:
		_gui.blueprint.modulate = Color.red
		
func _get_powered_neighbors(cellv:Vector2) -> int:
		var direction := 0
		
		for neighbor in Types.NEIGHBORS.keys():
			var neighbor_cellv = cellv + Types.NEIGHBORS[neighbor]
			if _tracker.is_cell_occupied(neighbor_cellv):
				var neighbor_entity: Node = _tracker.get_entity_at(neighbor_cellv)
				if (neighbor_entity.is_in_group(Types.POWER_MOVERS) or
					neighbor_entity.is_in_group(Types.POWER_RECEIVERS) or
					neighbor_entity.is_in_group(Types.POWER_SOURCES)):
						direction |= neighbor
						
		return direction

func _update_neighboring_flat_entities(cellv: Vector2) -> void:
	for neighbor in Types.NEIGHBORS.keys():
		var neighbor_cellv = cellv + Types.NEIGHBORS[neighbor]
		var neighbor_entity: Node = _tracker.get_entity_at(neighbor_cellv)
		if neighbor_entity and neighbor_entity is WireEntity:
			WireBlueprint.set_sprite_for_direction(neighbor_entity.sprite, 
				_get_powered_neighbors(neighbor_cellv))
