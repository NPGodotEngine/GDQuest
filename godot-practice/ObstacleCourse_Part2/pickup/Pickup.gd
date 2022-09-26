extends Area2D

onready var anim_player := $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	
func _on_body_entered(body:Node) -> void:
	anim_player.play("destroy")
	apply_effect(body)

func apply_effect(body:Node) -> void:
	pass
