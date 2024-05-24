class_name Unit extends PhysicsBody3D

@onready var selection_ring : MeshInstance3D = $SelectionRing
enum UnitType{BUILDING, PAWN, CAIRN}
enum UnitTeam{PLAYER,ENEMY,NEUTRAL}

@export var unit_type : UnitType
@export var unit_team : UnitTeam
@export var unit_resource : UnitResourceAutoLoad
@export var is_selected : bool = false
@export var sight_radius : float = 500
const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.ENEMY : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}


func _ready():
	set_unit_colour()

func set_unit_colour() -> void:
	if unit_team in k_team_colours:
		selection_ring.material_override = k_team_colours[unit_team]

func select():
	selection_ring.visible = true

func deselect():
	selection_ring.visible = false


# Create unit resources, with different types for buildings, units
# and subtypes for infantry, archers and workers/town hall, barracks etc

# KISS!!!!
