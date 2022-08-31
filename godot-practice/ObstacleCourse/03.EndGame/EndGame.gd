extends YSort

onready var godot: KinematicBody2D = $Godot
onready var robot_statue: Area2D = $RobotStatue

# Make this screen visible when touching the statue.
onready var finish_screen: Control = $CanvasLayer/FinishScreen


func _ready() -> void:
	robot_statue.connect("body_entered", self, "_on_RobotStatue_body_entered")


func _on_RobotStatue_body_entered(body: Node) -> void:
	finish_game()

func finish_game():
	godot.set_physics_process(false)
	finish_screen.show()
