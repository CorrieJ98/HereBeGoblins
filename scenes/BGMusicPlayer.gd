extends AudioStreamPlayer

var tracks = []
var current_track : int = 0

func _ready():
	load_audio_from_dir()
	

func load_audio_from_dir() -> void:
	for file in DirAccess.get_files_at("res://assets/Music/"):
		if file.get_extension() == ".mp3":
			tracks.append(ResourceLoader.load("res://assets/Music/"+file))

func next_track():
	if tracks != null:
		if current_track+1 > tracks.size():
			stream.resource_name = tracks[0]
			current_track = 0
		else:
			stream.resource_name = tracks[current_track+1]
			current_track += 1

func _on_finished():
	next_track()
