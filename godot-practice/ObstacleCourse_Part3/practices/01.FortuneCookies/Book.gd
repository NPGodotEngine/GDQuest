class_name Book
extends Resource

export(Array, String) var lines := []

func get_random_line() -> String:
	var index := randi() % lines.size()
	return lines[index]
