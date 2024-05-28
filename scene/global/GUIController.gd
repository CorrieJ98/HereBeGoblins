extends Control

var unit_img_button = preload("res://scene/units/worker_img.tscn")
var current_units = []


# Instantiate a new portrait per each selected unit
func _on_rts_controller_units_selected(units):
	current_units = units
	var units_grid = $UnitsGrid
	for n in units_grid.get_children():
		units_grid.remove_child(n)
		n.queue_free()
		
	for i in range(1,len(units)):
		var img_button = unit_img_button.instantiate()
		units_grid.add_child(img_button)
