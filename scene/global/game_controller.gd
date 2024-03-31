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
var master_profile = get("res://scene/global/master_profile.gd")
var profile_unit = get("res://scene/global/profile_unit.gd")
var profile_building = get("res://scene/global/profile_building.gd")
var ability = get("res://scene/global/ability.gd")
var camera_controller = get("res://scene/global/UI/camera_controller.gd")
var ui = get("res://scene/global/UI/ui.gd")

var units = []
var buildings = []

func _ready():
	# populate arrays with all objects in the scene of the relevant groups
	units = get_tree().get_nodes_in_group("units")
	buildings = get_tree().get_nodes_in_group("buildings")

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

func get_units_in_area(area):
	pass

func _on_area_selected():
	print("selected successfully passed")

func _on_select_unit():
	pass
