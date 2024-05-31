class_name Barracks extends Building

func _ready():
	super._ready()
	building_type = BuildingType.BARRACKS
	cost = 500
	spawning_unit = _TSCNREF.k_warrior
	spawning_unit_img = _TSCNREF.k_warrior_img
	
	unit_img = preload("res://assets/udemy/Project Assets/GUI/UnitBuildingImg.jpg")
