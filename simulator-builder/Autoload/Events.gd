extends Node

# Signal emmited when player placed an entity
# passing the entity and position in map coordinates
signal entity_placed(entity, cellv)

# Signal emmited when player removed an entity
# passing the entity and position in map coordinates
signal entity_removed(entity, cellv)

# Signal emitted when the simulation triggers the systems for updates.
signal system_ticked(delta)
