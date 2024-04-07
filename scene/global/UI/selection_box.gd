class_name SelectionBox extends Panel

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var is_dragging : bool = false

signal area_selected(object)
signal select_unit(object)

func _ready() -> void:
	var gc
	gc = get_node(".")
	
	# TODO 99% sure this will be problematic
	# "_on_area_selected" and "_on_selected_unit" do not exist
	connect("area_selected",Callable(gc,"_on_area_selected"), 2)
	connect("select_unit",Callable(gc, "_on_selected_unit"), 2)

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
			emit_signal("area_selected",self)
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
