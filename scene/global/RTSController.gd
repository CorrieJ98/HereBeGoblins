extends Node3D

@onready var cam : Camera3D = $Camera3D


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
	
	if Input.is_action_just_pressed("LeftMouseButton"):
		start_select_position = mouse_pos
	if Input.is_action_just_released("LeftMouseButton"):
		select_units()
	

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

func draw_ray_to_mouse(collision_mask : int) -> Dictionary:
	var ray_start : Vector3 = cam.project_ray_origin(mouse_pos)
	var ray_end : Vector3 = ray_start + cam.project_ray_normal(mouse_pos) * k_ray_length
	var space_state = get_world_3d().direct_space_state
	@warning_ignore("inferred_declaration")
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
	if k_player_team and result_unit.collider and result_unit.collider.unit_team == k_player_team:
		var selected_unit = result_unit.collider
		return selected_unit

func select_units():
	var main_unit = get_unit_under_mouse()
	if selected_units.size() != 0:
		old_selected_units = selected_units
	selected_units = []
	if mouse_pos.distance_squared_to(start_select_position) < 16:
		if main_unit != null:
			selected_units.append(main_unit)
			
	if selected_units.size() != 0:
		clean_new_selection(selected_units)
	elif selected_units.size() == 0:
		selected_units = old_selected_units

func clean_new_selection(new_units : Array) -> void:
	for unit in get_tree().get_nodes_in_group("units"):
		unit.deselect()
	for unit in new_units:
		unit.select()
