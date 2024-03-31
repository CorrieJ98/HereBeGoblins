class_name SelectionBox extends Panel

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var is_dragging : bool = false

signal area_selected
signal select_unit

func _ready() -> void:
	connect("area_selected",Callable(get_parent(), "on_area_selected_passthrough"))

func box_dragging() -> void:
	if Input.is_action_just_pressed("LeftMouseButton"):
		start = mousePosGlobal
		startV = mousePos
		is_dragging = true
	if is_dragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
	if Input.is_action_just_released("LeftMouseButton"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			is_dragging = false
			draw_area(false)

func draw_area(s : bool = true):
	size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x,endV.x)
	pos.y = min(startV.y, endV.y)
	position = pos
	size *= int(s)

func _input(event) -> void:
	if event is InputEventMouse:
		mousePos = event.position

func _process(delta) -> void:
	box_dragging()
