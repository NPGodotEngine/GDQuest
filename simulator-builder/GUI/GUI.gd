extends CenterContainer

# A reference to the inventory that belongs to the 'mouse'. It is a property
# that gives indirect access to DragPreview's blueprint through its getter
# function. No one needs to know that it is stored outside of the GUI class.
var blueprint: BlueprintEntity setget _set_blueprint, _get_blueprint

var mouse_in_gui: bool = false

onready var player_inventory := $HBoxContainer/InventoryWindow

# We use the reference to the drag preview in the setter and getter functions.
onready var _drag_preview := $DragPreview

onready var is_open: bool = $HBoxContainer/InventoryWindow.visible

onready var _gui_rect := $HBoxContainer

func _ready() -> void:
    # Here, we'll set up any GUI systems that require knowledge of the GUI node.
    player_inventory.setup(self)

func _process(delta: float) -> void:
    var mouse_position := get_global_mouse_position()
    mouse_in_gui = is_open and _gui_rect.get_rect().has_point(mouse_position)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_inventory"):
       if is_open:
        _close_inventories()
       else:
        _open_inventories()

func _open_inventories() -> void:
    is_open = true
    player_inventory.visible = true

func _close_inventories() -> void:
    is_open = false
    player_inventory.visible = false 

func destroy_blueprint() -> void:
    _drag_preview.destroy_blueprint()

func update_label() -> void:
    _drag_preview.update_label()

func _set_blueprint(value:BlueprintEntity) -> void:
    if not is_inside_tree():
        yield(self, "ready")
    _drag_preview.blueprint = value

func _get_blueprint() -> BlueprintEntity:
    return _drag_preview.blueprint


