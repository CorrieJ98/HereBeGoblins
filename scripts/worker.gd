class_name Worker extends Unit

@onready var build_timer = get_node("WorkTimer")
@onready var mine_timer = get_node("MineTimer")

var minerals : int = 0
var structure_to_build
var mineral_field_to_mine
var rock_mine = false
var mine_point = Vector3()

var closest_structure_point

func _ready():
	super._ready()
	
	unit_type = unit_types.WORKER
	cost = 35
	damage = 5
	unit_img = preload("res://assets/GUI/WorkerImg.jpg")

func create_structure(structure):
	var closest_structure_point = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), structure.position)
	structure.position = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), rts_controller.raycast_from_mouse(1).position)
	structure.create_structure(self)
	nav_region.add_child(structure)

func build_structure(structure):
	structure_to_build = structure
	move_to(lerp_from_self(structure_to_build.get_global_transform().origin))
	change_state("building")

func work():
	build_timer.start()
	speed = 0.0001
	state_machine.travel("Build")

func mine():
	speed = 0.0001
	state_machine.travel("Build")
	mine_timer.start()

func mining_repeat():
	move_to(mine_point)
	change_state("mining")

func return_to_base():
	var lowest_distance = 0
	var closest_building = null
	# get the closest accessible building
	for main_building in rts_controller.main_buildings:
		var distance_between = global_transform.origin.distance_to(main_building.global_transform.origin) 
		if lowest_distance == 0 or distance_between < lowest_distance:
			if main_building.active:
				closest_building = main_building
				lowest_distance = distance_between
	# then move towards it
	if closest_building != null:
		move_to(lerp_from_self(closest_building.get_global_transform().origin))
		change_state("mining")

func add_minerals():
	if minerals != 5:
		minerals += 5
		return_to_base()
		rock_mine = true 
		mine_timer.stop()

func mine_mineral_field(field):
	if minerals == 5:
		return_to_base()
	else:
		mineral_field_to_mine = field
		var pos_in_field = mineral_field_to_mine.get_field_pos()
		mine_point = lerp_from_self(pos_in_field)
		move_to(mine_point)
		change_state("mining")
		

func move_to(target_pos):
	super.move_to(target_pos)
	build_timer.stop()

func _on_navigation_agent_3d_target_reached():
	if current_state == states.BUILDING:
		work()
	elif current_state == states.MINING and !rock_mine:
		mine()
	elif current_state == states.ATTACKING:
		attack()
	elif current_state == states.MINING and rock_mine:
		await get_tree().create_timer(0.05).timeout
		minerals -= 5
		gui_controller.add_minerals(5)
		rock_mine = false
		mining_repeat()
	else:
		build_timer.stop()
		change_state("idle")

func lerp_from_self(pos) -> Vector3:
	var weight = 0.0
	var point = pos.lerp(get_global_transform().origin, weight)
	var desired_distance = 5
	
	# units are currently moving towards the new building but arent stopping to build
	# somethings wrong here but fuck today
	# aviv strikes again...cunt
	
	while point.distance_to(pos) > desired_distance:
		weight += 0.01
		point = pos.lerp(get_global_transform().origin, weight)
		if point.distance_to(pos) >= desired_distance:
			break
		if weight > 1.0:
			desired_distance += 1
			weight = 0.0
	return point

func _on_work_timer_timeout():
	structure_to_build.add_health(self)


func _on_mine_timer_timeout():
	mineral_field_to_mine.mine_rocks(self)

func _on_attack_timer_timeout():
	search_for_enemies("enemy")
