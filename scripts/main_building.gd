class_name MainBuilding extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	building_type = building_types.MAIN_BUILDING
	cost = 500
	spawning_unit = worker_unit
	spawning_img = worker_unit_img
	unit_img = preload("res://assets/GUI/MainBuildingImg.jpg")
	rts_controller.main_buildings.append(self)
	
	


func _on_tree_exited():
	rts_controller.main_buildings.erase(self)
