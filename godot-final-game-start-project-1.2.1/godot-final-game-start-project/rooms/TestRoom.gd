extends YSort

onready var spawner_mob := $SpawnerMob
onready var spawner_robot := $SpawnerRobot
onready var spawner_pickup := $SpawnerPickup
onready var spawner_teleporter := $SpawnerTeleporter

func _ready() -> void:
	spawner_mob.spawn()
	spawner_pickup.spawn()
	spawner_robot.spawn()
	spawner_teleporter.spawn()
