extends AudioStreamPlayer

@onready var musicTracks = [preload("res://src/audio/music/Forever Lost.wav"),
							preload("res://src/audio/music/Lost in the Dessert.wav"),
							preload("res://src/audio/music/Nostalgic.wav"),
							preload("res://src/audio/music/Warmth.wav")]

func _ready():
	while true:
		stream = musicTracks.pick_random()
		playing = true
		await finished
