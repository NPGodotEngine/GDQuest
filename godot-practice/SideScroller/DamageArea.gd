extends Area2D

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body:Node) -> void:
	get_tree().reload_current_scene()
