extends Node2D

onready var godot := $Course/Godot
onready var remaining_time_label := $CanvasLayer/RemainingTime
onready var timer := $Timer
onready var finish_line = $Course/FinishLine
onready var info_label = $CanvasLayer/Info
onready var anim_player = $AnimationPlayer

func _ready():
	godot.set_physics_process(false)
	finish_line.connect("body_entered", self, "_on_Finish_body_entered")
	timer.connect("timeout", self, "finish_game")
	
func _process(delta):
	remaining_time_label.text = get_time_as_text(timer.time_left)
	
func start():
	godot.set_physics_process(true)
	timer.start()

func get_time_as_text(time:float):
	return str(time).pad_decimals(2).pad_zeros(2)

func finish_game():
	set_process(false)
	godot.set_physics_process(false)
	
	info_label.rect_scale = Vector2.ONE
	info_label.get_font("font").size = 128
	info_label.visible = true
	
	var player_won : bool = timer.time_left > 0.0
	if player_won:
		var player_time : float = timer.wait_time - timer.time_left
		info_label.text = "You won!\nTime:" + get_time_as_text(player_time)
	else:
		info_label.text = "You lost!"
	
	anim_player.play("result")
	
	timer.stop()
	
func _on_Finish_body_entered(body:Node):
	finish_game()
