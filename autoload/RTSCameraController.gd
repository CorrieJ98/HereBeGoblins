class_name RTSCameraController extends GameController

@onready var cam : Camera2D = get_node("RTS/Camera2D")
const MOVE_SPEED : int = 15
const MARGIN : int = 5
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
		move_vec.x -= 1
	
	# Right Edge
	if mouse_pos.x > vp_size.x - MARGIN:
		move_vec.x += 1
	
	# Top Edge
	if mouse_pos.y <  MARGIN:
		move_vec.y -= 1
	
	# Bottom Edge
	if mouse_pos.y > vp_size.y - MARGIN:
		move_vec.y += 1
	
	cam.position += move_vec
	
func debug_print(a, b, c):
	print(a, b, c)
