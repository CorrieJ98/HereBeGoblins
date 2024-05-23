class_name Unit extends Node

enum UnitType{BUILDING, PAWN, CAIRN}
enum UnitTeam{PLAYER,ALLY,NEUTRAL,HOSTILE}

@export var unit_type : UnitType
@export var unit_team : UnitTeam
@export var unit_resource : UnitResourceAutoLoad
@export var is_selected : bool = false
@export var sight_radius : float = 500

# Create unit resources, with different types for buildings, units
# and subtypes for infantry, archers and workers/town hall, barracks etc

# KISS!!!!
