class_name Unit extends PhysicsBody3D

enum UnitType{BUILDING, PAWN, CAIRN}
enum UnitTeam{PLAYER,HOSTILE,NEUTRAL}

const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.HOSTILE : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}

func _ready():
	set_unit_colour()

func set_unit_colour() -> void:
	if unit_team in k_team_colours:
		$SelectionRing.material_override = k_team_colours[unit_team]

@export var unit_type : UnitType
@export var unit_team : UnitTeam
@export var unit_resource : UnitResourceAutoLoad
@export var is_selected : bool = false
@export var sight_radius : float = 500

# Create unit resources, with different types for buildings, units
# and subtypes for infantry, archers and workers/town hall, barracks etc

# KISS!!!!
