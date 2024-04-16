extends Node2D

var is_dragging = false  # are we currently dragging?
var selected = []  # array of selected units
var drag_start = Vector2.ZERO  # location where the drag begian
var select_rect = RectangleShape2D.new()

# item is definable as either a Unit or Building
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# If the mouse was clicked and nothing is selected, start dragging
			if selected.size() == 0:
				is_dragging = true
				drag_start = event.position
			# Otherwise a click tells the selected units to move
			else:
				for item in selected:
					item.collider.target = event.position
					item.collider.selected = false
				selected = []
		# If the mouse is released and is is_dragging, stop dragging and select the units
		elif is_dragging:
			is_dragging = false
			queue_redraw()
			var drag_end = event.position
			select_rect.extents = abs(drag_end - drag_start) / 2
			
			# TODO signal here to the game_controller.gd to populate arrays
			
			
			#var space = get_world_2d().direct_space_state
			#var q = PhysicsShapeQueryParameters2D.new()
			#q.shape = select_rect
			#q.collision_mask = 2
			#q.transform = Transform2D(0, (drag_end + drag_start) / 2)
			#selected = space.intersect_shape(q)
			#for item in selected:
				#item.append()
	if event is InputEventMouseMotion and is_dragging:
		queue_redraw()
		
func _draw():
	if is_dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
				Color.YELLOW, false, 2.0)
