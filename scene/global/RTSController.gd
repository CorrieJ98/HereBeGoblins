extends Node3D

@onready var cam : Camera3D = $Camera3D
@onready var selection_box = $UnitSelector

@export_range(10,250,5) var edge_pan_speed : int = 100
@export_range(50,300,5) var wasd_speed_scalar : int = 100
@export_range(0.01,0.5,0.01) var zoom_speed : float = 0.05
@export_category("Formations")
@export var units_in_circle : int = 4
@export var formation_radius : float = 20
@export var units_per_line : int = 6

const k_move_margin : int = 20
const k_ray_length : int = 1000
const k_player_team : int = Unit.UnitTeam.PLAYER
var mouse_pos := Vector2()
var selected_units := []
var old_selected_units := []
var start_select_position = Vector2()
var target_positions_list : Array[Vector3] = []
var unit_pos_index : int

func _process(delta) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	camera_movement(delta)
	
	# ===== Left Mouse Button Bindings =====
	# -- select point / begin drag
	if Input.is_action_just_pressed("LeftMouseButton"):
		selection_box.start_position = mouse_pos
		start_select_position = mouse_pos
	
	# -- confirm selection
	if Input.is_action_just_released("LeftMouseButton"):
		select_units()
	
	# -- hold to drag select
	if Input.is_action_pressed("LeftMouseButton"):
		selection_box.mouse_pos = mouse_pos
		selection_box.is_visible = true
	else:
		selection_box.is_visible = false
	
	# ===== Right Mouse Button Bindings ===== 
	# -- move command
	if Input.is_action_just_pressed("RightMouseButton"):
		move_selected_units()
		

func _input(event) -> void:
	# Cam Zoom
	if event.is_action_pressed("MWheelDown"):
		cam.fov = lerp(cam.fov , 75.0, zoom_speed)
	if event.is_action_pressed("MWheelUp"):
		cam.fov = lerp(cam.fov , 30.0, zoom_speed)
	


func camera_movement(dt : float) -> void:
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

func draw_ray_to_mouse(collision_mask : int):
	var ray_start : Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_end : Vector3 = ray_start + cam.project_ray_normal(mouse_pos) * k_ray_length
	var space_state = get_world_3d().direct_space_state
	var qp := PhysicsRayQueryParameters3D.new()
	
	qp.from = ray_start
	qp.to = ray_end
	qp.collision_mask = collision_mask
	qp.exclude = []
	return space_state.intersect_ray(qp)


# This can go into a single function
# func get_unit_under_mouse()

#if the team in rtscontroller and the selected unit are the same then continue

func get_unit_under_mouse():
	var result_unit = draw_ray_to_mouse(2)
	if result_unit and "unit_team" in result_unit.collider and result_unit.collider.unit_team == k_player_team:
		var selected_unit = result_unit.collider	
		return selected_unit

func select_units() -> void:
	var main_unit = get_unit_under_mouse()
	if selected_units.size() != 0:
		old_selected_units = selected_units
	selected_units = []
	
	# Check if the box dragging takes place on a tiny area, if it does, treat it as a single point click.
	if mouse_pos.distance_squared_to(start_select_position) < 16:
		if main_unit != null:
			selected_units.append(main_unit)
	else:
		# Otherwise, drag a box with these parameters
		selected_units = get_units_in_box(start_select_position, mouse_pos)
			
	if selected_units.size() != 0:
		clean_new_selection(selected_units)
	elif selected_units.size() == 0:
		selected_units = old_selected_units

func clean_new_selection(new_units : Array) -> void:
	for unit in get_tree().get_nodes_in_group("units"):
		unit.deselect()
	for unit in new_units:
		unit.select()

func move_selected_units() -> void:
	# 0b10111   ->   Allows tracking on layers 1, 2, 3 and 6
	# 1 = Map layer     2 = Pawns    3 = Buildings    6 = Resources
	#
	# This was some crazy, Udemy logic which I would never be able to
	# take credit for. It works though! :D
	unit_pos_index = 0
	var result = draw_ray_to_mouse(0b100111)
	if selected_units.size() != 0:
		var first_unit = selected_units[0]
		if result.collider.is_in_group("surface"):
			for unit in selected_units:
				position_units_in_formation(unit, result)
	
	

func get_units_in_box(topleft,botright) -> Array:
	if topleft.x > botright.x:
		var temp = topleft.x
		topleft.x = botright.x
		botright.x = temp
	if topleft.y > botright.y:
		var temp = topleft.y
		topleft.y = botright.y
		botright.y = temp
	
	var box = Rect2(topleft,botright - topleft)
	var boxed_units = []
	
	for unit in get_tree().get_nodes_in_group("units"):
		if unit.unit_team == k_player_team and box.has_point(cam.unproject_position(unit.global_transform.origin)):
			if boxed_units.size() <= 24:
				boxed_units.append(unit)
	return boxed_units

func set_formation_box(target_pos : Vector3, units_count : int):
	var line_positions_list : Array[Vector3] = []
	var positions_list : Array[Vector3] = []
	var new_target_pos = target_pos
	var xpos = 22
	var zpos = 22
	var lines = ceil(units_count/units_per_line)
	
	for i in units_per_line:
		line_positions_list.append(new_target_pos)
		positions_list.append(new_target_pos)
		new_target_pos = Vector3(target_pos.x + xpos, target_pos.y, target_pos.z)
		if i % 2 == 1:
			xpos -= 8
		xpos = -xpos
		
	for i in lines:
		for k in units_per_line:
			var new_pos = Vector3(line_positions_list[k].x,line_positions_list[k].y,line_positions_list[k].z + zpos)
			positions_list.append(new_pos)
		if i % 2 == 1:
			zpos -= 8
		zpos = -zpos
	return positions_list

func set_formation_circle(target_pos : Vector3, units_count : int):
	var positions : Array[Vector3] = []
	var origin = Vector2(target_pos.x,target_pos.z)
	var max_units_in_circle = units_in_circle
	var angle_step = PI * 2 / max_units_in_circle
	var angle = 0
	var units = 0
	var radius = formation_radius
	
	for i in range(0,units_count):
		if(units == max_units_in_circle):
			radius += 10
			units = 0
			angle = 0
			max_units_in_circle *= 2
			angle_step = PI * 2 / max_units_in_circle
		var dir = Vector2(cos(angle),sin(angle))
		var pos = origin + dir * radius
		var pos3d = Vector3(pos.x,0,pos.y)
		positions.append(pos3d)
		units += 1
		angle += angle_step
	return positions

func position_units_in_formation(unit, result):
	target_positions_list = set_formation_box(result.position, len(selected_units))
	unit.move_to(target_positions_list[unit_pos_index])
	unit_pos_index += 1
