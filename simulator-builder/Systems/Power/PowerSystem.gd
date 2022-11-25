class_name PowerSystem
extends Reference

## Holds a set of power source components keyed by their map position. We keep
## track of components to create "paths" that go from source to receiver,
## which informs the system update loop to notify those components of power flow.
var power_sources := {}

## Holds a set of power receiver components keyed by their map position.
## Same purpose as power sources, we use them to create paths between source and
## receiver used in the update loop.
var power_receivers := {}

## Holds a set of entities that transmit power, like wires, keyed by their map
## position. Used exclusively to create a path from a source to receiver(s).
var power_movers := {}

## Each element is an array of 'power paths'. Those arrays are map positions with [0] being
## the location of a power source and the rest being receivers.
## We use these power paths in the update loop to calculate the amount of power
## in any given path (which has one source and one or more receivers) and inform
## the source and receivers of the final number.
var paths := []

## The cells that are already verified while building a power path. This
## allows us to skip revisiting cells that are already in the list so we
## only travel outwards.
var cells_travelled := []

## We use this set to keep track of how much power each receiver has already gotten.
## If you have two power sources with `10` units of power each feeding a machine
## that takes `20`, then each will provide `10` over both paths.
var receivers_already_provided := {}

func _init() -> void:
	Events.connect("entity_placed", self, "_on_entity_placed")
	Events.connect("entity_removed", self, "_on_entity_removed")
	Events.connect("system_ticked", self, "_on_system_ticked")
	
func _get_power_source_from(entity:Node) -> PowerSource:
	for child in entity.get_children():
		if child is PowerSource:
			return child
	return null
	
func _get_power_receiver_from(entity:Node) -> PowerReceiver:
	for child in entity.get_children():
		if child is PowerReceiver:
			return child
	return null

func _on_entity_placed(entity:Node, cellv:Vector2) -> void:
	var retrace := false
	
	if entity.is_in_group(Types.POWER_SOURCES):
		power_sources[cellv] = _get_power_source_from(entity)
		retrace = true
	
	if entity.is_in_group(Types.POWER_RECEIVERS):
		power_receivers[cellv] = _get_power_receiver_from(entity)
		retrace = true
	
	if entity.is_in_group(Types.POWER_MOVERS):
		power_movers[cellv] = entity
		retrace = true
	
	if retrace:
		_retrace_paths()
	
func _on_entity_removed(entity:Node, cellv:Vector2) -> void:
	var retrace := power_sources.erase(cellv)
	retrace = power_receivers.erase(cellv)
	retrace = power_movers.erase(cellv)
	
	if retrace:
		_retrace_paths()

func _on_system_ticked(delta:float) -> void:
	receivers_already_provided.clear()
	
	for path in paths:
		# if we don't have power source
		if not power_sources.has(path[0]):
			continue
			
		# get power source
		var power_source: PowerSource = power_sources[path[0]]
		
		# amount of power the power source provied
		var source_power := power_source.get_effective_power()
		
		# remaining power equal to source power
		var remaining_power := source_power
		
		# amount of power power receivers has drawn
		var power_draw := 0.0
		
		for cell in path.slice(1, path.size()-1):
			# if cell in path is not power receiver
			# then skip it
			if not power_receivers.has(cell):
				continue
			
			# get power receiver	
			var power_receiver: PowerReceiver = power_receivers[cell]
			
			# amount of power the power receiver required
			var power_required := power_receiver.get_effective_power()
			
			if receivers_already_provided.has(cell):
				var receiver_total: float = receivers_already_provided[cell]
				if receiver_total >= power_required:
					continue
				else:
					power_required -= receiver_total
			
			power_receiver.emit_signal(
				"received_power", min(remaining_power, power_required), delta
				)
				
			power_draw = min(source_power, power_draw + power_required)
			
			if not receivers_already_provided.has(cell):
				receivers_already_provided[cell] = min(remaining_power, power_required)
			else:
				receivers_already_provided[cell] += min(remaining_power, power_required) 
			
			remaining_power = max(0, remaining_power - power_required)
			
			if remaining_power == 0:
				break;
		
		power_source.emit_signal("power_update", power_draw, delta)
		
func _retrace_paths() -> void:
	paths.clear()
	
	for source in power_sources:
		cells_travelled.clear()
		var path := _trace_path_from(source, [source])
		paths.push_back(path)

func _trace_path_from(cellv:Vector2, path:Array) -> Array:
	cells_travelled.push_back(cellv)
	
	var source_output_direction := 15
	if power_sources.has(cellv):
		source_output_direction = power_sources[cellv].output_direction
	
	# check for power receivers
	var receivers := _find_neighbors_in(cellv, power_receivers, source_output_direction)
	for receiver in receivers:
		if not receiver in cells_travelled and not receiver in path:
			# power flow direction from power source
			# to receiver
			var combined_direction := _combine_directions(receiver, cellv)
			var power_receiver: PowerReceiver = power_receivers[receiver]
			# If the current direction does not match any of the receiver's possible
			# directions (using the binary and operator, &, to check if the number fits
			# inside the other), skip this receiver and move on to the next one.
			if (
				(
					combined_direction & Types.Direction.RIGHT != 0
					and power_receiver.input_direction & Types.Direction.LEFT == 0
				)
				or (
					combined_direction & Types.Direction.DOWN != 0
					and power_receiver.input_direction & Types.Direction.UP == 0
				)
				or (
					combined_direction & Types.Direction.LEFT != 0
					and power_receiver.input_direction & Types.Direction.RIGHT == 0
				)
				or (
					combined_direction & Types.Direction.UP != 0
					and power_receiver.input_direction & Types.Direction.DOWN == 0
				)
			):
				continue
				
			# Otherwise, add it to the path.
			path.push_back(receiver)
			
	# We've done the receivers. Now, we check for any possible wires so we can keep
	# traveling.
	var movers := _find_neighbors_in(cellv, power_movers, source_output_direction)

	# Call this same function again from the new cell position for any wire that
	# found and travel from there, and return the result, so long as we
	# did not visit it already.
	# This is what makes the function recursive, that is to say, calling itself.
	for mover in movers:
		if not mover in cells_travelled:
			path = _trace_path_from(mover, path)

	# Return the final array
	return path
	
## Compare a source to a target map position and return a direction integer
## that indicates the direction power is traveling in.
func _combine_directions(receiver: Vector2, cellv: Vector2) -> int:
	if receiver.x < cellv.x:
		return Types.Direction.LEFT
	elif receiver.x > cellv.x:
		return Types.Direction.RIGHT
	elif receiver.y < cellv.y:
		return Types.Direction.UP
	elif receiver.y > cellv.y:
		return Types.Direction.DOWN

	return 0

## For each neighbor in the given direction, check if it exists in the collection we specify,
## and return an array of map positions with those that do.	
func _find_neighbors_in(cellv:Vector2, collection:Dictionary, output_direction:int=15) -> Array:
	var neighbors := []
	for neighbor in Types.NEIGHBORS.keys():
		if neighbor & output_direction != 0:
			var neighbor_cellv = cellv + Types.NEIGHBORS[neighbor]
			if collection.has(neighbor_cellv):
				neighbors.push_back(neighbor_cellv)
	return neighbors
