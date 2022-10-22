class_name SaveGame
extends Resource

export var player_1: Resource
export var player_2: Resource

const SAVE_GAME_PATH := "user://savegame.tres"

func write_savegame() -> void:
	ResourceSaver.save(SAVE_GAME_PATH, self)

static func load_savegame() -> Resource:
	if ResourceLoader.exists(SAVE_GAME_PATH):
		return load(SAVE_GAME_PATH)
	return null
