extends Area2D

onready var anim_player := $AnimationPlayer

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	
func on_body_entered(_body:Node):
	anim_player.play("chest_open")

func on_body_exited(_body:Node):
	anim_player.play_backwards("chest_open")
