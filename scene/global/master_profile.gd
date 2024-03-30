class_name MasterProfile extends Ability

var nodes = NodeAccessor.new()
var box = nodes.get_selection_box_node()
@export var is_selected := false

func get_selection():
	pass

func set_selected(is_vis : bool):
	box.visible = is_vis

func _ready():
	pass


# Horrendously messy but I can't #include in GDScript
class NodeAccessor extends Node:
	func get_selection_box_node() -> Panel:
		return get_node("Panel")
