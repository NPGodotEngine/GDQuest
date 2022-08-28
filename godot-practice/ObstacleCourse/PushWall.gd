extends Node2D

onready var area := $Area2D
onready var anim_player := $AnimationPlayer

func _ready() -> void:
	area.connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body:Node) -> void:
	anim_player.play("push_down")	
