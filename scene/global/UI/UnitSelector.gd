extends Control

var is_visible = false
var mouse_pos : Vector2
var start_position : Vector2

const k_box_colour = Color.DARK_GOLDENROD
const k_box_line_width = 5

func _draw():
	if is_visible and start_position != mouse_pos:
		move_to_front()
		var rect := Rect2(Vector2(mouse_pos.x,mouse_pos.y), Vector2(start_position.x - mouse_pos.x,start_position.y - mouse_pos.y))
		draw_rect(rect,k_box_colour,true,k_box_line_width)

