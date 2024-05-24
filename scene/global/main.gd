extends Node3D

func _ready():
	# lock mouse to game window
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _input(event):
	# Quit on ESC
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
