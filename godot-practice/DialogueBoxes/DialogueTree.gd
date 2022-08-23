extends PanelContainer

var dialogue = {
	0: {
		"text": "Hey, [i]wake up![/i] It's time to make video games.",
		"expression": "neutral",
		"buttons":
		{
			"Let me sleep a little longer": 2,
			"Let's do it!": 1,
		}
	},
	1: {
		"text": "Great! Your first task will be to write a [b]dialogue tree[/b].",
		"expression": "neutral",
		"buttons":
		{
			"I'm not sure if I'm ready, but I will do my best": 3,
			"No, let me go back to sleep": 2,
		}
	},
	2: {
		"text": "Oh, come on! It'll be fun.",
		"expression": "sad",
		"buttons":
		{
			"No, really, let me go back to sleep": 0,
			"Alright, I'll try": 3,
		}
	},
	3: {
		"text": "That's the spirit! You can do it!\n[wave][b]YOU WIN[/b][/wave]",
		"expression": "happy",
		"buttons": {}
	}
}

var portrait_dynamic_path := "res://DialogueBoxes/portraits/sophia_{expression}.png"

onready var rich_text_label := $MarginContainer/VBoxContainer/HBoxContainer/RichTextLabel
onready var texture_rect := $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
onready var button_column := $MarginContainer/VBoxContainer/ButtonColumn
onready var tween := $Tween
onready var audio_player := $AudioStreamPlayer

func _ready():
	show_line(0)
	tween.connect("tween_all_completed", self, "stop_audio")

func stop_audio():
	audio_player.stop()
		
func set_text(text:String):
	rich_text_label.bbcode_text = text
	var duration = text.length() / 30.0
	tween.interpolate_property(rich_text_label, "percent_visible", 0.0, 1.0, duration)
	tween.start()
	var audio_start_pos = randf() * audio_player.stream.get_length()
	audio_player.play(audio_start_pos)

func set_expression(exp_name:String):
	var exp_img_path = portrait_dynamic_path.format({"expression": exp_name})
	texture_rect.texture = load(exp_img_path)
	
func create_buttons(buttons:Dictionary):
	for button_title in buttons:
		var new_button = Button.new()
		var target_line_id = buttons[button_title]
		button_column.add_child(new_button)
		new_button.text = button_title
		new_button.connect("pressed", self, "show_line", [target_line_id])

func add_quit_button():
	var quit_button = Button.new()
	button_column.add_child(quit_button)
	quit_button.text = "Quit"
	quit_button.connect("pressed", self, "quit")
	
func show_line(id:int):
	if tween.is_active():
		tween.seek(INF)
		return
		
	var line : Dictionary = dialogue[id]
	set_text(line["text"])
	set_expression(line["expression"])
	
	for button in button_column.get_children():
		button.queue_free()
		
	if line.buttons:	
		create_buttons(line["buttons"])
	else:
		add_quit_button()

func quit():
	get_tree().quit()
	
