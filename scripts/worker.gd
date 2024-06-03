class_name Worker extends Unit

@onready var build_timer = get_node("WorkTimer")
@onready var mine_timer = get_node("MineTimer")

var minerals : int = 0
var structure_to_build
var mineral_field_to_mine
var is_mining = false
var mine_point = Vector3()

func _ready():
	super._ready()
	
	unit_type = unit_types.WORKER
	cost = 35
	damage = 5
	unit_img = preload("res://assets/GUI/WorkerImg.jpg")

func create_structure(structure):
	structure.position = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(),rts_controller.raycast_from_mouse(1).position)
	structure.create_structure(self)
	buildings_folder.add_child(structure)

func build_structure(structure):
	structure_to_build = structure
	move_to(lerp_from_self(structure_to_build.get_global_transform().origin))
	change_state("building")

func work():
	speed = 0.0001
	state_machine.travel("Build")
	build_timer.start()

func move_to(target_pos):
	super.move_to(target_pos)
	build_timer.stop()

func _on_navigation_agent_3d_target_reached():
	if current_state == states.BUILDING:
		work()
	else:
		build_timer.stop()
		change_state("idle")

func lerp_from_self(pos) -> Vector3:
	var change_point_by = 0.0
	var point = pos.lerp(get_global_transform().origin, change_point_by)
	var desired_distance = 100.0
	
	# units are currently moving towards the new building but arent stopping to build
	# somethings wrong here but fuck today
	while point.distance_to(pos) > desired_distance:
		change_point_by += 0.01
		point = position.lerp(get_global_transform().origin, change_point_by)
		if point.distance_to(pos) <= desired_distance:
			break
	
	return point

func _on_work_timer_timeout():
	structure_to_build.add_health(self)


func _on_mine_timer_timeout():
	pass # Replace with function body.
