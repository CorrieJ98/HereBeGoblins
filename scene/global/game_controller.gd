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

@onready var t_unit = Unit.new()
@onready var camera := get_node("Global/Camera2D")
@onready var nBuildings : Node = get_node("Level/Buildings")
@onready var nUnits : Node = get_node("Level/Units")
var grouped_units = []
var grouped_buildings = []
var selection_box : SelectionBox
var selection_border : Panel = null

func _ready():
	# t_unit is just an empty class, this needs reworked
	t_unit.get_selection_objects(selection_box,selection_border)
	populate_groups()
	populate_group_arrays()

func populate_group_arrays():
	# populate arrays with all objects in the scene of the relevant groups
	grouped_units = get_tree().get_nodes_in_group("unit_group_")
	grouped_buildings = get_tree().get_nodes_in_group("building_group_")

func populate_groups():
	
	# children of building/unit respectively
	var cob := [] 
	var cou := []
	
	cob = nBuildings.get_children(false)
	cou = nUnits.get_children(false)
	for item in cob:
		cob[item].add_to_group("building_group_", true)
	for item in cou:
		cou[item].add_to_group("unit_group_", true)
	
	make_array_unique(cob)

func make_array_unique(arr: Array) -> Array:
	var unique: Array = []
	
	for item in arr:
		if not unique.has(item):
			unique.append(item)
	return unique

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

func get_units_in_area(area : Array) -> Array:
	# u holds any units within our selected area
	var u = []
	
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
	var boxed_units = get_units_in_area(area)
	
	print(boxed_units, "
	--------------")
	
	for u in grouped_units:
		u.set_selected(false)
	
	for u in boxed_units:
		u.set_selected(!u.is_selected)

func _on_unit_selected(box):
	pass # Replace with function body.


# TODO
# I reckon i need to explicitly pass the SelectionBox into the game_controller.gd
# script in order to access the necessary variables. 
#
# POTENTIAL FIX
# lay out the entire UI scene inside the master scene. That way, its very easy to access
# the selection box
