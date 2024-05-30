extends Control


# ===== Units and Buildings Scenes =====
const k_townhall : PackedScene = preload("res://scene/buildings/townhall.tscn")
const k_barracks : PackedScene = preload("res://scene/buildings/barracks.tscn")
const k_worker : PackedScene = preload("res://scene/units/worker.tscn")
const k_warrior : PackedScene = preload("res://scene/units/warrior.tscn")

const k_townhall_img  : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/MainBuildingImg.jpg")
const k_barracks_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/UnitBuildingImg.jpg")
const k_worker_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WorkerImg.jpg")
const k_warrior_img : CompressedTexture2D = preload("res://assets/Udemy-AvivDavid/Project Assets/GUI/WarriorImg.jpg")

var unit_img_button = preload("res://scene/units/worker_img.tscn")
var current_units = []
var minerals : int = 1500

@onready var main_unit_img = $UnitPortrait/MainUnitImage
@onready var button_1_img = $SelectionBar/BuildingsGrid/OptionButton1
@onready var button_2_img = $SelectionBar/BuildingsGrid/OptionButton2
@onready var minerals_label = $Minerals/Label
@onready var buildings_grid = $SelectionBar/BuildingsGrid

var button_1_unit
var button_2_unit


func _ready():
	minerals_label.text = str(minerals)

# Instantiate a new portrait per each selected unit
# set the main portrait to be the very first unit selected
func _on_rts_controller_units_selected(units):
	current_units = units
	var units_grid = $UnitsGrid
	for n in units_grid.get_children():
		units_grid.remove_child(n)
		n.queue_free()
		
	for i in range(1,len(units)):
		var img_button = unit_img_button.instantiate()
		units_grid.add_child(img_button)
		img_button.texture_normal = units[i].unit_img
		
	main_unit_img.texture = current_units[0].unit_img
	set_button_images()

func hide_context_buttons():
	for button in buildings_grid.get_children():
		button.visible = false

func show_context_buttons(active_buttons):
	hide_context_buttons()
	for i in range(active_buttons):
		$SelectionBar/BuildingsGrid.get_child(i).visible = true


func _on_option_button_1_button_down():
	activate_button(button_1_unit)


func _on_option_button_2_button_down():
	activate_button(button_2_unit)

func set_button_images():
	if current_units[0] is TownHall:
		show_context_buttons(1)
		button_1_unit = k_worker
		button_1_img.texture_normal = k_worker_img
	elif current_units[0] is Barracks:
		show_context_buttons(1)
		button_1_unit = k_warrior
		button_1_img.texture_normal = k_warrior_img
	elif current_units[0] is Worker:
		show_context_buttons(2)
		button_1_unit = k_townhall
		button_1_img.texture_normal = k_townhall_img
		button_2_unit = k_barracks
		button_2_img.texture_normal = k_barracks_img 
	elif current_units[0] is Warrior:
		show_context_buttons(0)

func spend_minerals(num):
	minerals -= num
	minerals_label.text = str(minerals)

func add_minerals(num):
	minerals += num
	minerals_label.text = str(minerals)

func activate_button(button):
	var unit_button_ins = button.instantiate()
	var selected_unit = current_units[0]
	if unit_button_ins is Building:
		var unit_cost = unit_button_ins.cost
		if minerals >= unit_cost:
			spend_minerals(unit_cost)
	elif unit_button_ins is Unit:
		var unit_cost = unit_button_ins.cost
		if minerals >= unit_cost and selected_unit.current_created_units != selected_unit.max_units:
			spend_minerals(unit_cost)
			selected_unit.add_unit_to_spawn(unit_button_ins)
