extends CanvasLayer

@export var box : Panel

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
signal area_selected
signal start_move_selection

func _process(delta) -> void:
	box_dragging()

func box_dragging() -> void:
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			isDragging = false
			draw_area(false)


func _input(event):
	if event is InputEventMouse:
		mousePos = event.position

func draw_area(s=true):
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x,endV.x)
	pos.y = min(startV.y, endV.y)
	box.position = pos
	box.size *= int(s)
