class_name Building extends Node3D

const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.ENEMY : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}


var unit_img = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/MainBuildingImg.jpg")

enum UnitTeam{PLAYER,ENEMY,NEUTRAL}
enum BuildingType{TOWNHALL,BARRACKS}

@onready var unit_destination = $UnitDestination

var spawning_unit
var spawning_unit_img
var units_to_spawn = []
var is_under_construction : bool = false
var cost : int = 200
var max_units : int = 4
var current_created_units : int = 0
var units_imgs = []
var unit_building
var can_build = true

@export_category("Stats")
@export var health = 100
@export var building_type : BuildingType
@export var unit_team : UnitTeam
var progress_start = 10
var is_active = false
var is_rotating = false

func _ready():
	# ???
	add_to_group("units")
	if unit_team in k_team_colours:
		$SelectionRing.material_override = k_team_colours[unit_team]
	unit_destination.position = $UnitSpawnPoint.position + Vector3(0.1,0,0.1)

func select():
	$SelectionRing.visible = true

func deselect():
	$SelectionRing.visible = false
