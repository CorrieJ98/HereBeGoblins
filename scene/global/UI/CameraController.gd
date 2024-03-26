extends Camera2D

@export var zoom_factor : float = 1
@export var max_zoom :float = 15
@export var min_zoom : int = 7

var dir = Vector3(0,0,0)
var loc = transform.origin

// TODO dir.z == camera.zoom

	
func _input(event):
	loc = transform.origin

	if event is InputEventMouseButton:
		dir = Vector3(0,0,0)
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				if loc.z > min_zoom:
					dir.z -= 1
					translate(dir*zoom_factor)

			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if loc.z < max_zoom:
					dir.z += 1
					translate(dir*zoom_factor)
