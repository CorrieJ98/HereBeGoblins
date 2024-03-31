class_name UI extends CanvasLayer

@onready var selection_box = get_node("SelectionBox")

signal area_selected_passthrough
signal select_unit_passthrough


# pass emit signals from SelectionBox to master_scene
func _on_area_selected():
	emit_signal("area_selected_passthrough",selection_box)

func _on_select_unit():
	emit_signal("select_unit_passthrough", selection_box)
