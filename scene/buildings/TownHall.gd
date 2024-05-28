class_name TownHall extends Building

func _ready():
	super._ready()
	building_type = BuildingType.TOWNHALL
	#cost = 500
	#spawning_unit = k_worker
	#spawning_unit_img = k_worker_img
	#
	unit_img = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/MainBuildingImg.jpg")
