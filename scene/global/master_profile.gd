class_name MasterProfile extends Ability

# Horrendously messy hack-job, but I can't #include in GDScript
class PanelGetter extends Node:
	@onready var p: Panel = get_node("Panel")

var pg = PanelGetter.new()
var box = pg.p

@export var is_selected := false

func get_selection():
	pass

func set_selected(is_vis : bool):
	box.visible = is_vis

func _ready():
	pass

