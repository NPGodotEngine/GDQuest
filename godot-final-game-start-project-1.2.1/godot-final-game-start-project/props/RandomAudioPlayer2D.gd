class_name RandomAudioPlayer2D
extends AudioStreamPlayer2D

export (Array, AudioStream) var sounds := []
export var randomize_pitch := true

func play(from_position:float=0.0) -> void:
	if sounds:
		stream = sounds[randi() % sounds.size()]
	if randomize_pitch:
		pitch_scale = rand_range(0.9, 1.6)
	.play(from_position)
	

