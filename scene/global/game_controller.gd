class_name GameController extends Node

enum UnitCommand {MOVE,ATTACK,WORK}
enum BuildingCommand {SETRALLYPOINT, ATTACK}

var grouped_units : Array[Node]= []
var grouped_buildings : Array[Node] = []
var boxed_units : Array[Unit] = []
var selection_box : SelectionBox
var selection_border : Panel = null
var selection_area : Array[Vector2]
@onready var mouse_node = get_node("RTS/UI/MouseSelection")

func update_mouse():
	mouse_node.position = get_viewport().get_mouse_position()

func _process(delta):
	_RTS_CAMCONTROL._init()
	_RTS_CAMCONTROL.camera_movement(get_vp_mouse_position(), delta)
	_SELECTIONHANDLER._draw()
	

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	_RTS_CAMCONTROL.attach_cam($RTS/Camera2D)
	_SELECTIONHANDLER.attach_cam($RTS/Camera2D)
	populate_groups()
	populate_group_arrays()

func _input(event):
	_SELECTIONHANDLER._unhandled_input(event)
	
	if Input.is_action_just_pressed("RightMouseButton"):
		command_move_unit_selection(boxed_units)
	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func get_vp_mouse_position() -> Vector2:
	var mp = get_viewport().get_mouse_position()
	return mp

func populate_group_arrays():
	# populate arrays with all objects in the scene of the relevant groups
	grouped_units = get_tree().get_nodes_in_group("unit_group_")
	grouped_buildings = get_tree().get_nodes_in_group("building_group_")
	
	#print(grouped_units, " --units")
	#print(grouped_buildings, " --buildings")

func populate_groups():
	
	#TODO Issue #18 - Populate groups automatically on unit spawn
	
	pass

func get_units_under_mouse(mousepos : Vector2, grouped_units : Array[Unit]):
	for each in grouped_units:
		pass

func get_units_in_area(area : Array[Vector2]) -> Array:
	# u holds any units within our selected area
	var u : Array[Unit] = []
	
	# draw the box and check if a unit is present
	for each_unit in grouped_units:
		if each_unit.position.x > area[0].y and each_unit.position.x < area[1].x:
			if each_unit.position.y > area[0].x and each_unit.position.y < area[1].x:
				u.append(each_unit)
	return u

#func _draw():
	## PLEASE DONT TOUCH IT
	#if dragging:
		#if cam.offset != Vector2.ZERO:
			#draw_rect(Rect2(drag_start + cam.offset, get_viewport().get_mouse_position() - drag_start), Color.YELLOW, false, -1.0)
		#else:
			#draw_rect(Rect2(drag_start, get_viewport().get_mouse_position() - drag_start + cam.offset), Color.YELLOW, false, -1.0)
		#move_to_front()

func get_unit_mesh_in_area(area : Rect2) -> Array:
	var u : Array[Unit] = []
	
	# draw the box and check if there is a unit_mesh present
	for each in grouped_units:
		pass
		# if each mesh has collision event:
	
	return u
	pass

func _on_area_selected(box):
	var start : Vector2i = box.startV
	var end : Vector2i = box.endV
	var area = []
	
	print("startV: ", start)
	print("endV: ", end)
	
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	#boxed_units = get_units_in_area(area)
	boxed_units = get_units_in_area(_SELECTIONHANDLER.get_selection_area_as_vec_arr())
	
	print(boxed_units, "
	--------------")
	
	for u in grouped_units:
		u.set_selected(false)
	
	for u in boxed_units:
		u.set_selected(!u.is_selected)

func _on_unit_selected(box):
	pass


# TODO New function for command unit selection, taking a callable value of
# each possible UnitCommand enum
func command_move_unit_selection(selection : Array[Unit]) -> void:
	var is_player : bool = false
	var vel : Vector2
	
	for each in selection:
		# Firstly, ensure the selected unit does belong to the player
		# otherwise, deselect all units
		is_player = each.get_is_controllable()
		if is_player == false:
			selection.clear()
			break
		else:
			move_cmd_(each)

func move_cmd_(unit : Unit):
	var vp_mouse = get_viewport().get_mouse_position()
	var dt_movespeed = unit.profile.speed_walk * get_process_delta_time()
	var dist_to_move_point = vp_mouse - unit.position
	var dir : Vector2 
	
	if (unit.velocity.length() <= unit.profile.speed_walk):
		dir = unit.velocity
		dir *= dt_movespeed
		unit.velocity += dir
	
	if dist_to_move_point.length() <= 100:
		print("within 100, stopping")
		unit.velocity.move_toward(unit.position,1.0)
	
	#unit.velocity.angle_to_point(vdir)
	#unit.velocity.normalized()
	#unit.velocity.move_toward(vdir,get_process_delta_time() * unit.profile.speed_walk) 
	#unit.move_and_slide()
	#print(unit.velocity, " vel")
	#print(vdir, " vdir")

func attack_cmd_(unit : Unit):
	pass
