extends Camera2D

@export var max_zoom = 3.0
@export var max_unzoom = 0.4
@export var zoom_margin = 0.1
@export var cam_speed = 200.0
@export var zoom_speed = 20.0

var drag_cursor_shape = false
var mouseV = get_local_mouse_position()
var mouse = get_global_mouse_position()

func cam_pan(dt):
	if Input.is_action_pressed("CamPanNorth"):
		position.y -= cam_speed * dt
		
	if Input.is_action_pressed("CamPanEast"):
		position.x += cam_speed * dt
		
	if Input.is_action_pressed("CamPanSouth"):
		position.y += cam_speed * dt
		
	if Input.is_action_pressed("CamPanWest"):
		position.x -= cam_speed * dt

func _process(delta):
	cam_pan(delta)
	
	
	if drag_cursor_shape:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)
