class_name Building extends Node3D

@onready var unit_destination : MeshInstance3D = $UnitDestination
@onready var unit_h_box_container = $UnitProgressContainer.get_node("VBoxContainer/HBoxContainer")
@onready var unit_progress_bar = $UnitProgressContainer.get_node("VBoxContainer/UnitProgressBar")
@onready var unit_progress_container = $UnitProgressContainer
@onready var nav_mesh = get_parent()

#@export var unit_h_box_container : HBoxContainer
#@export var unit_progress_bar : ProgressBar
#@export var unit_progress_container : CanvasLayer

enum building_types { MAIN_BUILDING, UNIT_BUILDING }

const unit_img_button : PackedScene = preload("res://scenes/unit_img_button.tscn")
const worker_unit : PackedScene  = preload("res://scenes/worker.tscn")
const warrior_unit : PackedScene  = preload("res://scenes/warrior.tscn")
const worker_unit_img = preload("res://assets/GUI/WorkerImg.jpg")
const warrior_unit_img = preload("res://assets/GUI/WarriorImg.jpg")

var new_tween : Tween
var tween_callable_spawn_unit = Callable(self, "spawn_unit")
var tween_callable_spawn_repeat = Callable(self, "spawn_repeat")

var team : int = 0
var team_colours : Dictionary = {
	0: preload("res://assets/Materials/TeamBlueMat.tres"),
	1: preload("res://assets/Materials/TeamRedMat.tres")
}

var unit_img = preload("res://assets/GUI/MainBuildingImg.jpg")

var building_type
var spawning_unit
var spawning_img
var units_to_spawn : Array = []
var under_cons : bool = false

var cost : int = 200
var max_units_to_spawn : int = 4
var current_created_units : int = 0
var units_images : Array = []
var unit_building
var can_build : bool = true

var health : float = 100.0
var progress_start : float = 10.0
var active : bool = false
var is_rotating : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("units")
	
	if team in team_colours:
		$BuildingRing.material_override = team_colours[team]
	
	unit_destination.position = $UnitSpawnPoint.position + Vector3(0.1, 0, 0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func select():
	$BuildingRing.show()
	unit_destination.visible = true
	if current_created_units != 0:
		unit_progress_container.show()


func deselect():
	$BuildingRing.hide() 
	unit_destination.visible = false
	unit_progress_container.hide()


func add_unit_to_spawn(unit):
	if current_created_units < max_units_to_spawn:
		var unit_img = unit_img_button.instantiate()
		unit_img.texture_normal = spawning_img
		
		current_created_units += 1
		unit_h_box_container.add_child(unit_img)
		
		var callable = Callable(self, "cancel_unit")
		unit_img.pressed.connect(callable.bind(unit_img, unit))
		units_images.append(unit_img)
		units_to_spawn.append(unit)
		
		if current_created_units == 1:
			var tween := get_tree().create_tween()
			new_tween = tween
			new_tween.tween_property(unit_progress_bar, "value", 100.0, 3)
			new_tween.finished.connect(tween_callable_spawn_unit)
			spawn_repeat()
			unit_progress_container.show()


func spawn_repeat():
	new_tween.play()


func spawn_unit():
	new_tween.stop()
	
	var unit = spawning_unit.instantiate()
	units_to_spawn.remove_at(0)
	units_images.remove_at(0)
	unit_h_box_container.get_child(0).queue_free()
	
	var spawn_pos = NavigationServer3D.map_get_closest_point(get_world_3d().navigation_map, $UnitSpawnPoint.global_transform.origin)
	nav_mesh.add_child(unit)
	unit.global_transform.origin = spawn_pos
	unit.move_to(unit_destination.global_transform.origin)
	
	unit_progress_bar.value = 0
	current_created_units -= 1
	
	if current_created_units >= 1:
		spawn_repeat()
		new_tween.tween_callback(tween_callable_spawn_repeat)
	
	finish_spawning()


func finish_spawning():
	if current_created_units == 0:
		new_tween.kill()
		unit_progress_container.hide()
	else:
		unit_progress_container.show()


func cancel_unit(img, unit):
	if units_images[0] == img:
		unit_progress_bar.value = 0
		new_tween.stop()
		new_tween.play()
	
	units_to_spawn.erase(unit)
	unit.queue_free()
	units_images.erase(img)
	img.queue_free()
	current_created_units -= 1
	
	finish_spawning()


func move_to(target_pos):
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().navigation_map, target_pos)
	unit_destination.global_transform.origin = closest_pos
