extends Node

const BARRIER_ID := 1
const INVISIBLE_BARRIER := 2

export var simulation_speed := 1.0 / 30.0


var _tracker := EntityTracker.new()

onready var _ground_tile := $GameWorld/GroundTiles
onready var _player := $GameWorld/YSort/Player
onready var _entity_placer := $GameWorld/YSort/EntityPlacer
onready var _flat_entities := $GameWorld/FlatEntities
onready var _simulation_timer := $Timer
onready var _power_system := PowerSystem.new()

func _ready() -> void:
	_simulation_timer.connect("timeout", self, "_on_Timer_timeout")
	_simulation_timer.one_shot = false
	_simulation_timer.start(simulation_speed)
	
	# replace barriers with invisible barrier
	var barriers: Array = _ground_tile.get_used_cells_by_id(BARRIER_ID)
	for cellv in barriers:
		_ground_tile.set_cellv(cellv, INVISIBLE_BARRIER)
	
	# setup entity placer
	_entity_placer.setup(_tracker, _ground_tile, _flat_entities, _player)

func _on_Timer_timeout() -> void:
	Events.emit_signal("system_ticked", simulation_speed)
