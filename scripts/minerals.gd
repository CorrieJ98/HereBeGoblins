class_name MineralField extends StaticBody3D

var rocks : int
var mineral_pos : Array[Vector3] = []

func _ready():
	for mineral in get_children():
		if mineral is MeshInstance3D:
			mineral_pos.append(mineral.get_global_transform().origin)
	rocks = mineral_pos.size()

func mine_rocks(unit):
	unit.add_minerals()

func get_field_pos():
	if rocks == 0:
		rocks = mineral_pos.size()
	rocks -= 1
	return mineral_pos[rocks]
