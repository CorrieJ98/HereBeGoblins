class_name SelectionHandler extends Node2D

var dragging = false  # are we currently dragging?
var selected = []  # array of selected units
var drag_start : Vector2  # location where the drag begins
var drag_end : Vector2 # location where the drag ends
var select_rect = RectangleShape2D.new()
var vp_mouse_pos = _RTS_CAMCONTROL.mouse_pos
var cam : Camera2D

func attach_cam(c : Camera2D):
	cam = c

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# If the mouse was clicked and nothing is selected, start dragging
			if selected.size() == 0:
				dragging = true
				drag_start = event.position - cam.position
			# Otherwise a click tells the selected units to move
			else:
				for item in selected:
					item.collider.target = event.position - cam.position
					item.collider.selected = false
				selected = []
		# If the mouse is released and is dragging, stop dragging and select the units
		elif dragging:
			dragging = false
			queue_redraw()
			drag_end = event.position
			select_rect.extents = abs(drag_end - drag_start) * 0.5
			var space = get_world_2d().direct_space_state
			var q = PhysicsShapeQueryParameters2D.new()
			q.shape = select_rect
			q.collision_mask = 2
			q.transform = Transform2D(0, (drag_end - drag_start) * 0.5)
			selected = space.intersect_shape(q)
			for item in selected:
				item.collider.selected = true
	if event is InputEventMouseMotion and dragging:
		queue_redraw()
		
func _draw():
	#var size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	if dragging:
		draw_rect(Rect2(), Color.DARK_RED, false, -1.0)
		draw_rect(Rect2(drag_start, get_viewport().get_mouse_position() - drag_start), Color.YELLOW, false, -1.0)
		move_to_front()



func debug_print(a,b,c):
	print(a,b,c)
