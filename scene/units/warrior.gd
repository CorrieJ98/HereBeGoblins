class_name Warrior extends Unit

func _ready():
	# Run the _ready() func within Unit superclass
	super._ready()
	unit_type = UnitType.WARRIOR
	cost = 65
	atk_dmg = 10
	unit_img = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WarriorImg.jpg")
