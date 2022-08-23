extends GridContainer


func _ready() -> void:
	for i in 25:
		add_inventory_item()


func add_inventory_item() -> void:
	# Create an instance of InventoryItem.tscn.
	var inventory_item = preload("InventoryItem.tscn").instance()
	
	# Add it as a child of this node by calling the add_child() function.
	add_child(inventory_item)
