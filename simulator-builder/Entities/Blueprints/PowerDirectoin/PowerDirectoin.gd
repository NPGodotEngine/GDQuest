extends Node2D

## Arrows from the sprite sheet in a dictionary keyed with a description of which way
## the arrow faces.
const REGIONS := {
	"UpLeft": Rect2(899, 134, 31, 17),
	"DownRight": Rect2(950, 179, 31, 17),
	"UpRight": Rect2(950, 134, 31, 17),
	"DownLeft": Rect2(899, 179, 31, 17)
}

## A set of flags based on our `Types.Direction` enum. Allows you to choose the output 
## direction(s) for the entity.
export (Types.Direction, FLAGS) var output_directions := 15 setget _set_output_directions

## References to the scene's four sprite nodes.
onready var west := $W
onready var north := $N
onready var east := $E
onready var south := $S

## Compares the output directions to the `Types.Direction` enum and assigns the correct
## arrow texture to it.
func set_output_directions() -> void:
	if output_directions & Types.Direction.LEFT != 0:
		west.region_rect = REGIONS.UpLeft
	else:
		west.region_rect = REGIONS.DownRight
	
	if output_directions & Types.Direction.RIGHT != 0:
		east.region_rect = REGIONS.DownRight
	else:
		east.region_rect = REGIONS.UpLeft
	
	if output_directions & Types.Direction.UP != 0:
		north.region_rect = REGIONS.UpRight
	else:
		north.region_rect = REGIONS.DownLeft
	
	if output_directions & Types.Direction.DOWN != 0:
		south.region_rect = REGIONS.DownLeft
	else:
		south.region_rect = REGIONS.UpRight

func _set_output_directions(value:int) -> void:
	output_directions = value
	
	# Wait until the blueprint has appeared in the scene tree at least once.
	# We must do this as setters get called _before_ the node is in the scene tree,
	# meaning the sprites are not yet in their onready variables.
	if not is_inside_tree():
		yield(self, "ready")
		
	set_output_directions()
