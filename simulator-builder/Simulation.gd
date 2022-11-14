extends Node

const BARRIER_ID := 1
const INVISIBLE_BARRIER := 2

onready var _ground_tile := $GameWorld/GroundTiles

func _ready() -> void:
	var barriers: Array = _ground_tile.get_used_cells_by_id(BARRIER_ID)
	for cellv in barriers:
		_ground_tile.set_cellv(cellv, INVISIBLE_BARRIER)
