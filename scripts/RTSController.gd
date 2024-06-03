extends Node3D

signal units_selected(units : Array)

@onready var cam : Camera3D = $Camera3D
@onready var unit_selector = $UnitSelector

@export var units_in_circle : int = 4
@export var units_in_line : int = 6

const MOVE_MARGIN : int = 20
const RAY_LENGTH : int = 1000


@export_range(10,250,5) var edge_pan_speed : int = 100
@export_range(50,300,5) var wasd_speed_scalar : int = 100
@export_range(0.01,0.5,0.01) var zoom_speed : float = 0.05


var m_pos := Vector2()
var team : int = 0
var selected_units : Array = []
var old_selected_units : Array = []
var start_sel_pos := Vector2()
var target_positions_list : Array[Vector3] = []
var unit_pos_index : int = 0

var is_building = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../NavigationRegion3D/Buildings/MainBuilding".active = true

func _input(event):
	if event.is_action_pressed("MWheelDown"):
		cam.fov = lerp(cam.fov, 75.0, 0.25)
	if event.is_action_pressed("MWheelUp"):
		cam.fov = lerp(cam.fov, 35.0, 0.25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	m_pos = get_viewport().get_mouse_position()
	camera_movement(delta)
	
	if !is_building:
		#start_sel_pos = m_pos if Input.is_action_just_pressed("LeftMouseButton") else start_sel_pos
		
		if Input.is_action_just_pressed("LeftMouseButton"):
			unit_selector.start_pos = m_pos
			start_sel_pos = m_pos
		if Input.is_action_just_released("LeftMouseButton"):
			select_units()
		if Input.is_action_pressed("LeftMouseButton"):
			unit_selector.m_pos = m_pos
			unit_selector.is_visible = true
		else:
			unit_selector.is_visible = false
	
		if Input.is_action_just_pressed("RightMouseButton"):
			move_selected_units()

func camera_movement(dt):
	var viewport_size : Vector2 = get_viewport().size
	var origin : Vector3 = global_transform.origin
	var move_vec := Vector3()
	
	# ----- Edge Panning
	if origin.x > -62:
		if m_pos.x < MOVE_MARGIN:
			move_vec.x -= 1
	if origin.z > -65:
		if m_pos.y < MOVE_MARGIN:
			move_vec.z -= 1
	if origin.x < 62:
		if m_pos.x > viewport_size.x - MOVE_MARGIN:
			move_vec.x += 1
	if origin.z < 90:
		if m_pos.y > viewport_size.y - MOVE_MARGIN:
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
	
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rad_to_deg(rotation.y))
	move_vec.normalized()
	global_translate(move_vec * dt * edge_pan_speed)


func raycast_from_mouse(collision_mask) -> Dictionary:
	var ray_start : Vector3 = cam.project_ray_origin(m_pos)
	var ray_end : Vector3 = ray_start + cam.project_ray_normal(m_pos) * RAY_LENGTH
	var space_state = get_world_3d().direct_space_state
	var prqp := PhysicsRayQueryParameters3D.new()
	
	prqp.from = ray_start
	prqp.to = ray_end
	prqp.collision_mask = collision_mask
	prqp.exclude = []
	
	return space_state.intersect_ray(prqp)


func get_unit_under_mouse():
	var result_unit = raycast_from_mouse(0b110)
	if result_unit and "team" in result_unit.collider and result_unit.collider.team == team:
		return result_unit.collider


func select_units() -> void:
	var main_unit = get_unit_under_mouse()
	if selected_units.size() != 0:
		old_selected_units = selected_units
		selected_units = []
	
	if m_pos.distance_squared_to(start_sel_pos) < 16:
		if main_unit != null:
			selected_units.append(main_unit)
	else:
		selected_units = get_units_in_box(start_sel_pos, m_pos)
	
	if selected_units.size() != 0:
		clean_current_units_and_apply_new(selected_units)
		emit_signal("units_selected", selected_units)
	elif selected_units.size() == 0:
		selected_units = old_selected_units


func clean_current_units_and_apply_new(new_units) -> void:
	for unit in get_tree().get_nodes_in_group("units"):
		unit.deselect()
	for unit in new_units:
		unit.select()


func move_selected_units() -> void:
	# 0b100111 passes Layers 1,2,3 and 6
	# udemy brain hack, idk why it doesnt parse
	var result = raycast_from_mouse(0b100111)
	unit_pos_index = 0
	if selected_units.size() != 0:
		var first_unit = selected_units[0]
		if result.collider.is_in_group("surface"):
			if first_unit is Building:
				first_unit.move_to(result.position)
			elif first_unit is Unit:
				for unit in selected_units:
					position_units(unit, result)
		elif result.collider is Building:
			for unit in selected_units:
				if unit is Unit:
					if unit is Worker:
						unit.build_structure(result.collider)
					elif unit is Warrior:
						position_units(unit,result)


func get_units_in_box(top_left, bot_right) -> Array:
	var box = Rect2(top_left, bot_right - top_left)
	var box_abs = box.abs()
	var box_selected_units = []
	
	if top_left.x > bot_right.x:
		var tmp = top_left.x
		top_left.x = bot_right.x
		bot_right.x = tmp
	if top_left.y > bot_right.y:
		var tmp = top_left.y
		top_left.y = bot_right.y
		bot_right.y = tmp
	
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.team == team and box_abs.has_point(cam.unproject_position(unit.global_transform.origin)):
			if box_selected_units.size() <= 24:
				box_selected_units.append(unit)
	
	return box_selected_units


func create_units_position_in_a_circle(target_pos : Vector3, units_num : int) -> Array[Vector3]:
	var positions_list : Array[Vector3] = []
	var radius : float = 1.0
	var centre : Vector2 = Vector2(target_pos.x, target_pos.z)
	var max_units_in_circle = units_in_circle
	var angle_step = PI * 2 / max_units_in_circle
	var angle = 0
	var unit_count = 0
	
	for i in range(0, units_num):
		var direction = Vector2(cos(angle), sin(angle))
		var pos = centre + direction * radius
		var pos_3d = Vector3(pos.x, 0, pos.y)
		
		if unit_count == max_units_in_circle:
			radius += 1.0
			unit_count = 0
			angle = 0
			max_units_in_circle *= 2
			angle_step = PI * 2 / max_units_in_circle
		
		positions_list.append(pos_3d)
		unit_count += 1
		angle += angle_step
	
	return positions_list


func create_units_positions_in_rect(target_pos : Vector3, units_num : int) -> Array[Vector3]:
	var line_positions_list : Array[Vector3] = []
	var positions_list : Array[Vector3] = []
	var new_target_pos = target_pos
	var x_pos = 1
	var z_pos = 1
	var num_of_lines = ceil(units_num/units_in_line)
	
	for i in units_in_line:
		line_positions_list.append(new_target_pos)
		positions_list.append(new_target_pos)
		new_target_pos = Vector3(target_pos.x + x_pos, target_pos.y, target_pos.z)
		
		if i % 2 == 1:
			x_pos -= 1
		
		x_pos = -x_pos
		
	for i in num_of_lines:
		for k in units_in_line:
			var new_pos = Vector3(line_positions_list[k].x, line_positions_list[k].y, line_positions_list[k].z + z_pos)
			positions_list.append(new_pos)
		
		if i % 2 == 1:
			z_pos -= 1

		z_pos = -z_pos
	
	return positions_list


func position_units(unit, result):
	target_positions_list = create_units_positions_in_rect(result.position, len(selected_units))
	unit.move_to(target_positions_list[unit_pos_index])
	unit_pos_index += 1
