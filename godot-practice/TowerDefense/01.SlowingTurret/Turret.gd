extends Area2D


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body: Node) -> void:
	# Divide the body's speed by 2.
	body.speed /= 2.0


func _on_body_exited(body: Node) -> void:
	# Multiply the body's speed by 2 to restore its original speed.
	body.speed *= 2.0
