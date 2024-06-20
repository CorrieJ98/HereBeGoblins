class_name UnitBuilding extends Building


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	
	building_type = building_types.UNIT_BUILDING
	cost = 300
	spawning_unit = warrior_unit
	spawning_img = warrior_unit_img
	unit_img = preload("res://assets/GUI/UnitBuildingImg.jpg")
