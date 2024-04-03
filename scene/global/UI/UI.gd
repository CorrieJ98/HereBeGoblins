class_name UI extends CanvasLayer

@onready var sb = get_node("SelectionBox")

# THIS IS FINE
@onready var gc = get_parent().get_parent()

signal gc_area_selected(object)
signal gc_unit_selected(object)

func selection_box_area_selected(object):
	emit_signal("gc_area_selected",sb)

func selection_box_unit_selected(object):
	emit_signal("gc_unit_selected",sb)
