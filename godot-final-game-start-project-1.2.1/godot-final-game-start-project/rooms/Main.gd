tool
extends YSort

export (Array, PackedScene) var rooms := []
export var grid_width := 2
export var grid_height := 2
export var room_size := Vector2(13, 13) * 128

onready var music_player := $MusicPlayer
onready var ui_pause_layer := $UILayer/PauseScreen

var current_room_index := 0
var last_room_index := grid_width * grid_height - 1

func _get_configuration_warning() -> String:
	update_configuration_warning()
	if rooms.size() == 0:
		return "rooms must contain at least 1 scene"
	for i in range(rooms.size()):
		if not rooms[i]:
			return "rooms %sth scene is empty" % [str(i+1)]
	
	return ""

func _ready() -> void:
	print("main ready")
	randomize()
	Events.connect("resume_game", self, "_on_Event_resume_game")
	Events.connect("pause_game", self, "_on_Envent_pause_game")
	Events.connect("restart_game", self, "_on_Event_restart_game")
	Events.connect("quit_game", self, "_on_Event_quit_game")
	
	generate_level()
	ui_pause_layer.hide()
	music_player.play()

func _on_Event_resume_game() -> void:
	get_tree().paused = false
	
func _on_Envent_pause_game() -> void:
	get_tree().paused = true

func _on_Event_restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Event_quit_game() -> void:
	get_tree().quit()

func generate_level() -> void:
	assert(rooms.size() > 0, "Main scene must have at least one room in array")
	
	for x in range(grid_width):
		for y in range(grid_height):
			var room: BaseRoom = rooms[randi() % rooms.size()].instance()
			assert(room is BaseRoom, "room instance is not inherited from BaseRoom")
			add_child(room)
			var room_position = room_size * Vector2(x, y)
			room.global_position = room_position
			
			room.spawn_items()
			if current_room_index == 0:
				room.spawn_robot()
			elif current_room_index == last_room_index:
				room.spawn_mobs()
				room.spawn_teleporter()
			else:
				room.spawn_mobs()
			
			if x == 0:
				room.hide_left_bridge()
			elif x == grid_width-1:
				room.hide_right_bridge()
				
			if y == 0:
				room.hide_top_bridge()
			elif y == grid_height-1:
				room.hide_bottom_bridge()
			
			current_room_index += 1
