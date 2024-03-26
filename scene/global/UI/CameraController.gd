extends Camera2D

@export var zoom_percentage = 15
@export var max_zoom = 3.0
@export var max_unzoom = 0.4

var drag_cursor_shape = false
var mouseV = get_local_mouse_position()
var mouse = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			drag_cursor_shape = true
			position.move_toward(mouseV,1.0)
		else:
			drag_cursor_shape = false

	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom += Vector2.ONE * zoom_percentage / 100
				if zoom.x > max_zoom:
					zoom = Vector2.ONE * max_zoom
					return
				position += get_local_mouse_position() / 10
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= Vector2.ONE * zoom_percentage / 100
				if zoom.x < max_unzoom:
					zoom = Vector2.ONE * max_unzoom

func _process(delta):
	if drag_cursor_shape:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)
