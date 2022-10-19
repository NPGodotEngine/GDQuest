class_name CharacterStats
extends Resource

export var strength := 2 setget set_strength
export var endurance := 2 setget set_endurance
export var intelligence := 2 setget set_intelligence

func set_strength(new_strength:int) -> void:
	strength = new_strength
	save() 

func set_endurance(new_endurance:int) -> void:
	endurance = new_endurance
	save() 

func set_intelligence(new_intelligence:int) -> void:
	intelligence = new_intelligence
	save() 

func save() -> void:
	ResourceSaver.save(resource_path, self)
