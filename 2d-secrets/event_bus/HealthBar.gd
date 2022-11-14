extends TextureProgress

func _ready() -> void:
	Events.connect("player_health_changed", self, "_on_player_health_changed")
	
func _on_player_health_changed(health, max_health):
	min_value = 0
	max_value = max_health
	value = health
