extends CenterContainer

## Each of the action as listed in the input map. We place them in an array so we
## can iterate over each one.
const QUICKBAR_ACTIONS := [
    "quickbar_1",
    "quickbar_2",
    "quickbar_3",
    "quickbar_4",
    "quickbar_5",
    "quickbar_6",
    "quickbar_7",
    "quickbar_8",
    "quickbar_9",
    "quickbar_0"
]

# A reference to the inventory that belongs to the 'mouse'. It is a property
# that gives indirect access to DragPreview's blueprint through its getter
# function. No one needs to know that it is stored outside of the GUI class.
var blueprint: BlueprintEntity setget _set_blueprint, _get_blueprint

var mouse_in_gui: bool = false

onready var player_inventory := $HBoxContainer/InventoryWindow
onready var quickbar := $MarginContainer/QuickBar

# We use the reference to the drag preview in the setter and getter functions.
onready var _drag_preview := $DragPreview

onready var is_open: bool = $HBoxContainer/InventoryWindow.visible

onready var _gui_rect := $HBoxContainer

func _ready() -> void:
    # Here, we'll set up any GUI systems that require knowledge of the GUI node.
    player_inventory.setup(self)
    quickbar.setup(self)

func _process(delta: float) -> void:
    var mouse_position := get_global_mouse_position()
    mouse_in_gui = is_open and _gui_rect.get_rect().has_point(mouse_position)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_inventory"):
       if is_open:
        _close_inventories()
       else:
        _open_inventories()
    else:
        for i in QUICKBAR_ACTIONS.size():
            if InputMap.event_is_action(event, QUICKBAR_ACTIONS[i]) and event.is_pressed():
                _simulate_input(quickbar.panels[i])
                break

func _simulate_input(panel: InventoryPanel) -> void:
    var input := InputEventMouseButton.new()
    input.button_index = BUTTON_LEFT
    input.pressed = true
    panel._gui_input(input)

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


