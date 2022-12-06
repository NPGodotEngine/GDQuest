extends Control

export (Vector2) var preview_offset := Vector2.ZERO

# The blueprint object held by the drag preview. We use a setter function to
# ensure it's displayed on-screen.
var blueprint: BlueprintEntity setget _set_blueprint

# We need access to the label to display the stack count on-screen.
onready var count_label := $Label

func _ready() -> void:
    # The control will always stick to the mouse at all times. We don't want it
    # to be controlled by the GUI's CenterContainer. Otherwise, every frame, it
    # will be sent back to the middle of the screen.
    # Setting the node as `toplevel` makes its transform independent from its
    # parents.
    set_as_toplevel(true)

# Events in `_input()` happen regardless of the state of the GUI and they
# happen first so this callback is ideal for global events like matching the
# mouse position on the screen.
func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        rect_global_position = get_global_mouse_position() + preview_offset

# A helper function to keep the label up-to-date with the stack count. We can
# call this whenever the stack's amount changes.
func update_label() -> void:
    if blueprint and blueprint.stack_count > 1:
        count_label.text = str(blueprint.stack_count)
        count_label.show()
    else:
        count_label.hide()

# This function both removes the blueprint from the scene tree, but also frees
# it and calls `update_label()`.
func destroy_blueprint() -> void:
    if blueprint:
        remove_child(blueprint)
        blueprint.queue_free()
        blueprint = null
        update_label()

func _set_blueprint(value:BlueprintEntity) -> void:
    if blueprint and blueprint.get_parent() == self:
        remove_child(blueprint)
    
    blueprint = value
    if blueprint:
        add_child(blueprint)
        move_child(blueprint, 0)
    
    update_label()
    