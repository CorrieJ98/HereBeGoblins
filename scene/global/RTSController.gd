extends Node3D

const k_move_margin := 20

@onready var cam : Camera3D = $Camera3D

var mouse_pos := Vector2()

@export_range(10,250,5) var edge_pan_speed : int = 100
@export_range(50,300,5) var wasd_speed_scalar : int = 100
@export_range(0.01,0.5,0.01) var zoom_speed : float = 0.05

func _process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	camera_movement(mouse_pos,delta)

func _input(event):
	# Cam Zoom
	if event.is_action_pressed("MWheelDown"):
		cam.fov = lerp(cam.fov , 75.0, zoom_speed)

	if event.is_action_pressed("MWheelUp"):
		cam.fov = lerp(cam.fov , 30.0, zoom_speed)

func camera_movement(mouse_pos, dt):
	var vp_size : Vector2 = get_viewport().size
	var origin : Vector3 = global_transform.origin
	var move_vec := Vector3()
	
	# pan camera if mouse is at edge and camera is within map bounds
	if origin.x > -1000:
		if mouse_pos.x < k_move_margin:
			move_vec.x -= 1
	if origin.z > -1000:
		if mouse_pos.y < k_move_margin:
			move_vec.z -= 1
	if origin.x < 1000:
		if mouse_pos.x > vp_size.x - k_move_margin:
			move_vec.x += 1
	if origin.z < 1000:
		if mouse_pos.y > vp_size.y - k_move_margin:
			move_vec.z += 1
	
	
	# ----- WASD Panning
	if Input.is_action_pressed("CamPanNorth"):
		move_vec.z -= (wasd_speed_scalar * dt)
		move_vec.normalized()
	
	if Input.is_action_pressed("CamPanEast"):
		move_vec.x += (wasd_speed_scalar * dt)
		move_vec.normalized()
		
	if Input.is_action_pressed("CamPanSouth"):
		move_vec.z += (wasd_speed_scalar * dt)
		move_vec.normalized()
		
	if Input.is_action_pressed("CamPanWest"):
		move_vec.x -= (wasd_speed_scalar * dt)
		move_vec.normalized()
	
	move_vec = move_vec.rotated(Vector3(0,1,0), rad_to_deg(rotation.y))
	global_translate(move_vec * dt * edge_pan_speed)
