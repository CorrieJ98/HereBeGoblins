class_name SelectionHandler extends Node2D

var dragging = false  # are we currently dragging?
var selected = []  # array of selected units
var drag_start : Vector2  # location where the drag begins
var drag_end : Vector2 # location where the drag ends
var select_rect = RectangleShape2D.new()
var vp_mouse_pos = _RTS_CAMCONTROL.mouse_pos
var cam : Camera2D
var grouped_buildings : Array[Node]
var grouped_units : Array[Node]

signal area_selected(box)
signal point_selected(v2 : Vector2)


func attach_cam(c : Camera2D):
	cam = c

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# If the mouse was clicked and nothing is selected, start dragging
			if selected.size() == 0:
				dragging = true
				drag_start = event.position
				print("selected: ", selected)
			# Otherwise a click tells the selected units to move
			elif event.is_released() && drag_end == drag_start:
				emit_signal("point_selected", drag_start + cam.offset)
		# If the mouse is released and is dragging, stop dragging and select the units
		elif dragging:
			dragging = false
			queue_redraw()
			drag_end = event.position
			select_rect.extents = abs(drag_end - drag_start) * 0.5
			
			# I would explain this section in greater detail if I had any understanding of it.
			var space = get_world_2d().direct_space_state
			var q = PhysicsShapeQueryParameters2D.new()
			q.shape = select_rect
			q.collision_mask = 2
			q.transform = Transform2D(0, (drag_end - drag_start) * 0.5)
			selected = space.intersect_shape(q, 255)
			for item in selected:
				item.collider.selected = true
			#drag_start = Vector2.ZERO
			
			emit_signal("area_selected", get_selection_area_as_vec_arr())
	if event is InputEventMouseMotion and dragging:
		queue_redraw()

var sbox : Rect2

# PLEASE OH GOD DONT FUCKING TOUCH THIS ITS HELD TOGETHER WITH PRAYERS
func _draw():
	# PLEASE DONT TOUCH IT
	if dragging:
		if cam.offset != Vector2.ZERO:
			draw_rect(Rect2(drag_start + cam.offset, get_viewport().get_mouse_position() - drag_start), Color.YELLOW, false, -1.0)
		else:
			draw_rect(Rect2(drag_start, get_viewport().get_mouse_position() - drag_start + cam.offset), Color.YELLOW, false, -1.0)
		move_to_front()

func get_selection_area_as_vec_arr() -> Array[Vector2]:
	
	# take selection coords as 4 points of a rect rather than drag start and end maybe???
	
	var a : Array[Vector2]
	if a.size() > 2:
		a.clear()
	
	if cam.offset != Vector2.ZERO:
		a.clear()
		a.append(drag_start + cam.offset)
		a.append(get_viewport().get_mouse_position() - drag_start)
		return a
	else:
		a.clear()
		a.append(drag_start)
		a.append(get_viewport().get_mouse_position() - drag_start + cam.offset)
		return a

func debug_print(a,b,c):
	print(a,b,c)
