class_name CamController extends Camera2D

@export var zoom_in_max := 2.5
@export var zoom_out_max = 0.5
@export var cam_speed = 500.0

var max_zoom = Vector2(zoom_in_max,zoom_in_max)
var max_unzoom = Vector2(zoom_out_max,zoom_out_max)

var drag_cursor_shape = false
var mouseV = get_local_mouse_position()
var mouse = get_global_mouse_position()
var threshold = 100
var step = 10
@onready var viewport_size = get_viewport().size

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
	update_window_scaling()

func _physics_process(delta):
	cam_pan(delta)
	
	if drag_cursor_shape:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_DRAG)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = lerp(zoom, zoom * 2.0, 0.1)
			global_position = lerp(global_position, get_global_mouse_position(),0.1)
			if zoom >= max_zoom:
				zoom = max_zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = lerp(zoom, zoom *  0.5, 0.1)
			global_position = lerp(global_position, get_global_mouse_position(),0.1)
			if zoom <= max_unzoom:
				zoom = max_unzoom

func edge_panning():
	if mouseV.x < threshold:
		position.x -= step
	elif mouseV.x > viewport_size.x - threshold:
		position.x += step

func update_window_scaling() -> Vector2i:
	return get_viewport().size
