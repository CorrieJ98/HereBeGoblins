class_name TownHall extends Building

func _ready():
	super._ready()
	building_type = BuildingType.TOWNHALL
	cost = 500
	spawning_unit = _TSCNREF.k_worker
	spawning_unit_img = _TSCNREF.k_worker_img
	
	unit_img = preload("res://assets/udemy/Project Assets/GUI/MainBuildingImg.jpg")
