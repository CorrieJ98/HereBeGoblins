class_name Building extends Node3D

const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.ENEMY : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}

const k_unit_img_button = preload("res://scene/global/UI/unit_img_button.tscn")

# ===== Units and Buildings Scenes =====
const k_townhall : PackedScene = preload("res://scene/buildings/townhall.tscn")
const k_barracks : PackedScene = preload("res://scene/buildings/barracks.tscn")
const k_worker : PackedScene = preload("res://scene/units/worker.tscn")
const k_warrior : PackedScene = preload("res://scene/units/warrior.tscn")

const k_townhall_img  : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/MainBuildingImg.jpg")
const k_barracks_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/UnitBuildingImg.jpg")
const k_worker_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WorkerImg.jpg")
const k_warrior_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WarriorImg.jpg")

enum UnitTeam{PLAYER,ENEMY,NEUTRAL}
enum BuildingType{TOWNHALL,BARRACKS, CAIRN}

@onready var unit_destination = get_node("UnitDestination")
@onready var unit_hbox = get_node("UnitProgressContainer/VBoxContainer/HBoxContainer")
@onready var unit_progress_bar = get_node("UnitProgressContainer/VBoxContainer")
@onready var unit_progress_container = get_node("UnitProgressContainer")
@onready var navmesh = get_parent().get_parent()
var unit_img = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/MainBuildingImg.jpg")

# Create Tween
var new_tween : Tween
var tween_callable_spawn_unit = Callable(self,"spawn_unit")
var tween_callable_spawn_repeat = Callable(self,"spawn_repeat")

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
	unit_destination.visible = true

func deselect():
	$SelectionRing.visible = false
	unit_destination.visible = true


func add_unit_to_spawn(unit):
	if current_created_units < max_units:
		var unit_img = k_unit_img_button.instantiate()
		unit_img.texture_normal = spawning_unit_img
		current_created_units += 1
		unit_hbox.add_child(unit_img)
		
		var callable = Callable(self,"cancel_unit")
		unit_img.pressed.connect(callable.bind(unit_img,unit))
		units_imgs.append(unit_img)
		units_to_spawn.append(unit)
		if current_created_units == 1:
			var tween := get_tree().create_tween()
			new_tween = tween
			new_tween.tween_property(unit_progress_bar,"value", 100.0,3)
			spawn_repeat()
			unit_progress_container.visible = true

func spawn_repeat():
	new_tween.finished.connect(tween_callable_spawn_unit)


# TODO nonexistent function 'instantiate' in base 'RigidBody3D (Warrior)
func spawn_unit():
	new_tween.stop()
	var unit = spawning_unit.instantiate()
	units_to_spawn.remove_at(0)
	units_imgs.remove_at(0)
	unit_hbox.get_child(0).queue_free()
	var spawnpos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), $UnitSpawnPoint.global_transform.origin)
	unit.global_transform.origin = spawnpos
	unit.move_to(unit_destination.global_transform.origin)
	unit_progress_bar.value = 0
	current_created_units -= 1
	
	if current_created_units >= 1:
		new_tween.play()
		new_tween.tween_callback(tween_callable_spawn_repeat)
	finish_spawning()

func finish_spawning() -> void:
	if current_created_units == 0:
		new_tween.kill()
		unit_progress_container.visible = false
	else:
		unit_progress_container.visible = true

func cancel_unit(img,unit) -> void:
	if units_imgs[0] == img:
		unit_progress_bar.value = 0
		new_tween.stop()
		new_tween.play()
	units_to_spawn.erase(unit)
	unit.queue_free()
	units_imgs.erase(img)
	img.queue_free()
	current_created_units -= 1
	finish_spawning()
