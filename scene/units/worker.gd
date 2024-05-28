extends Unit

func _ready():
	# Run the _ready() func within Unit superclass
	super._ready()
	unit_type = UnitType.WORKER
	cost = 35
	atk_dmg = 3
	unit_img = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WorkerImg.jpg")
