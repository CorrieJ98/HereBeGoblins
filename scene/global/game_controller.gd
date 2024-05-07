class_name GameController extends Node

# Pointing toward
const DIRECTION = {
	"NORTH": Vector2(0, 1),
	"NORTHWEST": Vector2(-1, 1),
	"WEST": Vector2(-1, 0),
	"SOUTHWEST": Vector2(-1, -1),
	"SOUTH": Vector2(0, -1),
	"SOUTHEAST": Vector2(1, -1),
	"EAST": Vector2(1, 0),
	"NORTHEAST": Vector2(1, 1),
}

enum UnitCommand {MOVE,ATTACK,WORK}
enum BuildingCommand {SETRALLY, ATTACK}

#@onready var t_unit = Unit.new()
@onready var camera := get_node("Global/Camera2D")

var grouped_units : Array[Node]= []
var grouped_buildings : Array[Node] = []
var boxed_units : Array[Unit] = []
var selection_box : SelectionBox
var selection_border : Panel = null

static func get_direction_string(v : Vector2) -> Vector2i:
	v.normalized()
	match v:
		DIRECTION.NORTH:
			return DIRECTION.NORTH
		DIRECTION.NORTHEAST:
			return DIRECTION.NORTHEAST
		DIRECTION.EAST:
			return DIRECTION.EAST
		DIRECTION.SOUTHEAST:
			return DIRECTION.SOUTHEAST
		DIRECTION.SOUTH:
			return DIRECTION.SOUTH
		DIRECTION.SOUTHWEST:
			return DIRECTION.SOUTHWEST
		DIRECTION.WEST:
			return DIRECTION.WEST
		DIRECTION.NORTHWEST:
			return DIRECTION.NORTHWEST
		_:
			return v

func _ready():
	# t_unit is just an empty class, this needs reworked
#	t_unit.get_selection_objects(selection_box,selection_border)
	populate_groups()
	populate_group_arrays()

func _input(event):
	if Input.is_action_just_pressed("RightMouseButton"):
		command_move_unit_selection(boxed_units)

func populate_group_arrays():
	# populate arrays with all objects in the scene of the relevant groups
	grouped_units = get_tree().get_nodes_in_group("unit_group_")
	grouped_buildings = get_tree().get_nodes_in_group("building_group_")
	
	print(grouped_units, " --units")
	print(grouped_buildings, " --buildings")

func populate_groups():
	
	#TODO Issue #18 - Populate groups automatically on unit spawn
	
	pass

func get_units_in_area(area : Array) -> Array:
	# u holds any units within our selected area
	var u : Array[Unit] = []
	
	# draw the box and check if a unit is present
	for each_unit in grouped_units:
		if each_unit.position.x > area[0].y and each_unit.position.x < area[1].x:
			if each_unit.position.y > area[0].x and each_unit.position.y < area[1].x:
				u.append(each_unit)
	return u

func _on_area_selected(box):
	var start : Vector2i = box.startV
	var end : Vector2i = box.endV
	var area = []
	
	print("startV: ", start)
	print("endV: ", end)
	
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	boxed_units = get_units_in_area(area)
	
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
