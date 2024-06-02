class_name MainBuilding extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	building_type = building_types.MAIN_BUILDING
	cost = 500
	spawning_unit = worker_unit
	spawning_img = worker_unit_img
	unit_img = preload("res://assets/GUI/MainBuildingImg.jpg")


# 11 mins section 9 - 42

func _on_build_area_body_entered(body):
	pass # Replace with function body.


func _on_build_area_body_exited(body):
	pass # Replace with function body.
