class_name SelectionBox extends Panel

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var is_dragging : bool = false

signal area_selected(box)
signal select_unit(profile)
signal units_selected(units : Array[Unit])

func _ready() -> void:
	pass

# TODO Rework selection entirely: This should be a rect, it should pass a signal
# to all relevant objects (units and buildings) on the screen that, if they are
# within the borders of the selectionbox, their is_selected bool shall be truthy
# Issue #28

func draw_area(isSelecting : bool = true):
	size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x,endV.x)
	pos.y = min(startV.y, endV.y)
	position = pos
	size *= int(isSelecting)

func box_dragging() -> void:
	if Input.is_action_just_pressed("LeftMouseButton"):
		start = get_viewport().get_global_mouse_position()
		startV = get_viewport().get_mouse_position()
		is_dragging = true
	if is_dragging:
		end = get_viewport().get_global_mouse_position()
		endV = get_viewport().get_mouse_position()
		draw_area()
	if Input.is_action_just_released("LeftMouseButton"):
		if startV.distance_to(mousePos) > 20:
			end = get_viewport().get_global_mouse_position()
			endV = get_viewport().get_mouse_position()
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected",self)
		else:
			end = start
			is_dragging = false
			draw_area(false)

func _input(event) -> void:
	if event is InputEventMouse:
		mousePos = event.position

func _process(delta) -> void:
	box_dragging()
