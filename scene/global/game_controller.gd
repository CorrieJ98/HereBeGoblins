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

# Script references
var unit = get("res://scene/global/unit.gd")
var building = get("res://scene/global/building.gd")
var profile_unit = get("res://scene/global/profile_unit.gd")
var profile_building = get("res://scene/global/profile_building.gd")
var ability = get("res://scene/global/ability.gd")
var camera_controller = get("res://scene/global/UI/camera_controller.gd")
var ui = get("res://scene/global/UI/ui.gd")

var units = []
var buildings = []

func _ready():
	populate_groups()
	populate_group_arrays()

func populate_group_arrays():
	# populate arrays with all objects in the scene of the relevant groups
	units = get_tree().get_nodes_in_group("units")
	buildings = get_tree().get_nodes_in_group("buildings")

func populate_groups():
	pass
	
	# get.tree for both Units and Buildings nodes, and automatically
	# fill the corresponding groups 
	# see https://github.com/CorrieJ98/HereBeGoblins/issues/18 for details

func get_direction_string(v : Vector2) -> Vector2i:
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

func get_units_in_area(area : Array):
	# u holds any units within our selected area
	var u = []
	
	# draw the box and check if a unit is present
	for units in units:
		if(units.position.x > area[0].y) and (units.position.x < area[1].x):
			if(units.position.y > area[0].x) and (units.position.y < area[1].x):
				u.append(unit)
	
	return u

# don't fuck with the names on these
func _on_ui_gc_area_selected(object):
	var start = object.start
	var end = object.end
	var area : Array = []
	
	area.append(Vector2(min(start.x,end.x),min(start.y,end.y)))
	area.append(Vector2(max(start.x,end.x),max(start.y,end.y)))
	
	var ut = get_units_in_area(area)
	
	for u in units:
		pass
	
	for u in ut:
		u.set_selected(!u.is_selected)
		print("is_selected swapped")

func _on_ui_gc_unit_selected(object):
	pass # Replace with function body.
