extends YSort

const SKIP_TIME := 9.8

onready var obstacle_course := $ViewportsRow/ViewportContainer/Viewport/Course
onready var finish_area := obstacle_course.get_node("Finish")

onready var ui_layer := $UI
onready var ui_info := ui_layer.get_node("Info")
onready var ui_remaining_time := ui_layer.get_node("RemainingTime")
onready var timer := $Timer
onready var animation_player := $AnimationPlayer

onready var split_viewports_container := $ViewportsRow
onready var viewport_overview_container := $OverviewViewportContainer

onready var viewport_overview := $OverviewViewportContainer/Viewport
onready var viewport_left := split_viewports_container.get_node("ViewportContainer/Viewport")
onready var viewport_right := split_viewports_container.get_node("ViewportContainer2/Viewport")

onready var players := [obstacle_course.get_node("PlayerCharacter"), obstacle_course.get_node("PlayerCharacter2")]

onready var ui_customized_character := $Menu/UICustomizeCharacter

var _savegame: SaveGame = null

func _create_savegame() -> void:
	_savegame = SaveGame.new()
	_savegame.player_1 = preload("TwoPlayersDemo/Player_1_setting.tres").duplicate()
	_savegame.player_2 = preload("TwoPlayersDemo/Player_2_setting.tres").duplicate()
	_savegame.write_savegame()
	
func _ready() -> void:
	timer.connect("timeout", self, "finish_game")
	finish_area.connect("body_entered", self, "_on_Finish_body_entered")

	set_process(false)
	for player in players:
		player.set_physics_process(false)

	ui_remaining_time.text = get_remaining_time_text(true)

	animation_player.play("course_overview")
	animation_player.queue("start_countdown")

	viewport_right.world_2d = viewport_left.world_2d
	viewport_overview.world_2d = viewport_right.world_2d
	
	_savegame = SaveGame.load_savegame()
	if not _savegame:
		_create_savegame()
		_savegame = SaveGame.load_savegame()
	
	players[0].settings = _savegame.player_1
	players[1].settings = _savegame.player_2
	
	ui_customized_character.setup(_savegame)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and animation_player.current_animation == "course_overview":
		animation_player.seek(SKIP_TIME)
		set_process_unhandled_input(false)
		
func _input(event) -> void:
	if event.is_action_pressed("toggle_options_menu"):
		if not ui_customized_character.visible:
			ui_customized_character.show()
		else:
			ui_customized_character.hide()
			_savegame.write_savegame()
		get_tree().paused = ui_customized_character.visible


func _process(delta: float) -> void:
	ui_remaining_time.text = get_remaining_time_text(false)


func start() -> void:
	set_process(true)
	for player in players:
		player.set_physics_process(true)
	timer.start()


func show_split_screen() -> void:
	split_viewports_container.show()
	viewport_overview_container.hide()


func finish_game(body: KinematicBody2D) -> void:
	animation_player.play("finish_game")
	ui_info.text = "You lost!"

	if timer.time_left > 0.0:
		ui_info.text = "You won!\nRemaining time: " + get_remaining_time_text(false)
	set_process(false)
	for player in players:
		player.set_physics_process(false)
	timer.stop()


func get_remaining_time_text(is_in_ready: bool) -> String:
	var time: float = timer.time_left
	if is_in_ready:
		time = timer.wait_time
	return str(time).pad_decimals(2)


func _on_Finish_body_entered(body: Node) -> void:
	finish_game(body)
