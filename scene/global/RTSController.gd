extends Node3D

@onready var cam : Camera3D = $Camera3D
@onready var selection_box = $UnitSelector

@export_range(10,250,5) var edge_pan_speed : int = 100
@export_range(50,300,5) var wasd_speed_scalar : int = 100
@export_range(0.01,0.5,0.01) var zoom_speed : float = 0.05
const k_move_margin : int = 20
const k_ray_length : int = 1000
const k_player_team : int = Unit.UnitTeam.PLAYER
var mouse_pos := Vector2()
var selected_units := []
var old_selected_units := []
var start_select_position = Vector2()

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
	var result = draw_ray_to_mouse(0b100111)
	if selected_units.size() != 0:
		var first_unit = selected_units[0]
		if result.collider.is_in_group("surface"):
			for unit in selected_units:
				unit.move_to(result.position)

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
