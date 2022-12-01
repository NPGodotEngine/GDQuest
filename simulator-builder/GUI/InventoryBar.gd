# Class that represents a bar of inventory slots.
# Forwards function calls and signals from and to children.
class_name InventoryBar
extends HBoxContainer

# A scene resource for the inventory panel, a scene we'll create next and that represents 
# individual item slots.
export var inventory_panel_scene: PackedScene

# How many panels to create as children of the bar.
export var slot_count := 10

# An array of references to the panels we create so we can refer to them and
# check their contents later.
var panels := []

func _ready() -> void:
    _make_panels()

# Creates several inventory panel instances as a child of this horizontal bar.
# Adds them to the `panels` object variable.
func _make_panels() -> void:
    for _i in slot_count:
        var panel := inventory_panel_scene.instance()
        add_child(panel)
        panels.append(panel)