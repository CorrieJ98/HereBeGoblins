#class_name SelectionBox extends Panel

# See issue #28

class_name SelectionBox extends Area2D

@onready var detection_collider := get_node("SelectionDetectionArea")

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var is_dragging : bool = false

signal area_selected(box)
signal select_unit(profile)

func _ready() -> void:
	pass

func draw_area(isSelecting : bool = true):
	detection_collider.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x,endV.x)
	pos.y = min(startV.y, endV.y)
	position = pos
	detection_collider.size *= int(isSelecting)

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

func _input(event) -> void:
	if event is InputEventMouse:
		mousePos = event.position

func _process(delta) -> void:
	box_dragging()
