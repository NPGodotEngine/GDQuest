extends Node

const BARRIER_ID := 1
const INVISIBLE_BARRIER := 2

var _tracker := EntityTracker.new()

onready var _ground_tile := $GameWorld/GroundTiles
onready var _player := $GameWorld/YSort/Player
onready var _entity_placer := $GameWorld/YSort/EntityPlacer
onready var _flat_entities := $GameWorld/GameWorld/FlatEntities

func _ready() -> void:
	# replace barriers with invisible barrier
	var barriers: Array = _ground_tile.get_used_cells_by_id(BARRIER_ID)
	for cellv in barriers:
		_ground_tile.set_cellv(cellv, INVISIBLE_BARRIER)
	
	# setup entity placer
	_entity_placer.setup(_tracker, _ground_tile, _flat_entities _player)
