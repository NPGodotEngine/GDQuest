class_name Entity
extends Node2D

# Item as string that is required to deconstruct this entity
export var deconstructor_filter: String

# Number of item drop after this entity is deconstructed
export var pickup_count := 1

func _setup(_blueprint) -> void:
	pass
