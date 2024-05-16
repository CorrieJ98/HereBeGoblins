class_name RTSCameraController extends GameController

@onready var cam : Camera2D = get_node("RTS/Camera2D")
const MOVE_SPEED : float = 2.5
const MARGIN : int = 4
var mouse_pos : Vector2

func _init() -> void:
	if cam != null:
		if cam == Camera2D:
			cam.make_current()

func attach_cam(c : Camera2D):
	cam = c

func camera_movement(m_pos, dt):
	mouse_pos = get_viewport().get_mouse_position()
	var vp_size : Vector2 = get_viewport().size
	var origin := Vector2(vp_size.x * 0.5, vp_size.y * 0.5)
	var move_vec := Vector2()
	var mouse_pos_from_origin = mouse_pos - origin
	move_vec *= dt * MOVE_SPEED
	
	# ----- Edge panning
	# Left Edge
	if mouse_pos.x < MARGIN:
		move_vec.x -= MOVE_SPEED
	
	# Right Edge
	if mouse_pos.x > vp_size.x - MARGIN:
		move_vec.x += MOVE_SPEED
	
	# Top Edge
	if mouse_pos.y <  MARGIN:
		move_vec.y -= MOVE_SPEED
	
	# Bottom Edge
	if mouse_pos.y > vp_size.y - MARGIN:
		move_vec.y += MOVE_SPEED
	
	
	# ----- WASD Panning
	if Input.is_action_pressed("CamPanNorth"):
		move_vec.y -= MOVE_SPEED
	
	if Input.is_action_pressed("CamPanEast"):
		move_vec.x += MOVE_SPEED
		
	if Input.is_action_pressed("CamPanSouth"):
		move_vec.y += MOVE_SPEED
		
	if Input.is_action_pressed("CamPanWest"):
		move_vec.x -= MOVE_SPEED
	
	cam.offset += move_vec
	
func debug_print(a, b, c):
	print(a, b, c)
