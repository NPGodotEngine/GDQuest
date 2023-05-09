extends Node

# Signal emmited when player placed an entity
# passing the entity and position in map coordinates
signal entity_placed(entity, cellv)

# Signal emmited when player removed an entity
# passing the entity and position in map coordinates
signal entity_removed(entity, cellv)

# Signal emitted when the simulation triggers the systems for updates.
signal system_ticked(delta)

# Signal emitted when the player has arrived at an item that can be picked up
signal entered_pickup_area(entity, player)

# Emitted when the mouse hovers over any entity
signal hovered_over_entity(entity)

# Emitted when an entity updates its tooltip
signal info_updated(entity)