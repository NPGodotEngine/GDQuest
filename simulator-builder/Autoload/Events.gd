extends Node

# Signal emmited when player placed an entity
# passing the entity and position in map coordinates
signal entity_placed(entity, cellv)

# Signal emmited when player removed an entity
# passing the entity and position in map coordinates
signal entity_removed(entity, cellv)
