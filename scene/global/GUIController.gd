extends Control

var unit_img_button = preload("res://scene/units/worker_img.tscn")
var current_units = []

# ===== Units and Buildings Scenes =====
const k_townhall : PackedScene = preload("res://scene/buildings/townhall.tscn")
const k_barracks : PackedScene = preload("res://scene/buildings/barracks.tscn")
const k_worker : PackedScene = preload("res://scene/units/worker.tscn")
const k_warrior : PackedScene = preload("res://scene/units/warrior.tscn")

const k_townhall_img  : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/MainBuildingImg.jpg")
const k_barracks_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/UnitBuildingImg.jpg")
const k_worker_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WorkerImg.jpg")
const k_warrior_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WarriorImg.jpg")

@onready var main_unit_img = $UnitPortrait/MainUnitImage
@onready var button1_img = $SelectionBar/BuildingsGrid/OptionButton1
@onready var button2_img = $SelectionBar/BuildingsGrid/OptionButton2
#@onready var minerals_label = $Minerals/Label

var button1_unit
var button2_unit

# Instantiate a new portrait per each selected unit
# set main image to first unit in selection
func _on_rts_controller_units_selected(units):
	current_units = units
	var units_grid = $UnitsGrid
	for n in units_grid.get_children():
		units_grid.remove_child(n)
		n.queue_free()
		
	for i in range(1,len(units)):
		var img_button = unit_img_button.instantiate()
		units_grid.add_child(img_button)
	
	main_unit_img.texture = current_units[0].unit_img
	set_button_images()

func hide_buttons():
	for button in $SelectionBar/GridContainer.get_children():
		button.visible = false

func show_buttons(num):
	hide_buttons()
	for i in range(num):
		$SelectionBar/GridContainer.get_child(i).visible = true


func _on_button_1_button_down():
	pass # Replace with function body.


func _on_button_2_button_down():
	pass # Replace with function body.


# What can each unit or building create?
func set_button_images():
	if current_units[0] is TownHall:
		show_buttons(1)
		button1_unit = k_worker
		button1_img = k_worker_img
	if current_units[0] is Barracks:
		show_buttons(1)
		button1_unit = k_warrior
		button1_img = k_warrior_img
	if current_units[0] is Worker:
		show_buttons(2)
		button1_unit = k_townhall
		button1_img = k_townhall_img
		button1_unit = k_barracks
		button1_img = k_barracks_img
	if current_units[0] is Warrior:
		show_buttons(0)
