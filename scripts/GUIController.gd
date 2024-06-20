extends Control

@onready var main_unit_img = $MainUnitImgContainer/MainUnitImg
@onready var option_button_one_img = $SelectionBar/BuildingsGrid/OptionButton1
@onready var option_button_two_img = $SelectionBar/BuildingsGrid/OptionButton2
@onready var minerals_label = $Minerals/Label

const main_building : PackedScene = preload("res://scenes/main_building.tscn")
const unit_building : PackedScene = preload("res://scenes/unit_building.tscn")
const worker_unit : PackedScene = preload("res://scenes/worker.tscn")
const warrior_unit : PackedScene = preload("res://scenes/warrior.tscn")

const main_building_img : CompressedTexture2D = preload("res://assets/GUI/MainBuildingImg.jpg")
const unit_building_img : CompressedTexture2D = preload("res://assets/GUI/UnitBuildingImg.jpg")
const unit_worker_img : CompressedTexture2D = preload("res://assets/GUI/WorkerImg.jpg")
const unit_warrior_img : CompressedTexture2D = preload("res://assets/GUI/WarriorImg.jpg")

var unit_img_button = preload("res://scenes/unit_img_button.tscn")
var current_units = []
var option_button_one_unit
var option_button_two_unit
var num_minerals : int = 5000

# Called when the node enters the scene tree for the first time.
func _ready():
	minerals_label.text = str(num_minerals)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rts_controller_units_selected(units):
	var units_grid = $UnitsGrid
	current_units = units
	
	for n in units_grid.get_children():
		units_grid.remove_child(n)
		n.queue_free()
	
	for i in range(1, len(units)):
		var img_button = unit_img_button.instantiate()
		units_grid.add_child(img_button)
		img_button.texture_normal = units[i].unit_img
	
	main_unit_img.texture = current_units[0].unit_img
	set_button_images()


func hide_buttons():
	for button in $SelectionBar/BuildingsGrid.get_children():
		button.hide()


func show_buttons(active_buttons_num):
	hide_buttons()
	for i in range(active_buttons_num):
		$SelectionBar/BuildingsGrid.get_child(i).show()


func _on_option_button_1_pressed():
	activate_button(option_button_one_unit)


func _on_option_button_2_pressed():
	activate_button(option_button_two_unit)


func set_button_images():
	if current_units[0] is MainBuilding:
		show_buttons(1)
		option_button_one_unit = worker_unit
		option_button_one_img.texture_normal = unit_worker_img
	elif current_units[0] is UnitBuilding:
		show_buttons(1)
		option_button_one_unit = warrior_unit
		option_button_one_img.texture_normal = unit_warrior_img
	elif current_units[0] is Worker:
		show_buttons(2)
		option_button_one_unit = main_building
		option_button_one_img.texture_normal = main_building_img
		option_button_two_unit = unit_building
		option_button_two_img.texture_normal = unit_building_img
	elif current_units[0] is Warrior:
		show_buttons(0)


func spend_minerals(num):
	num_minerals -= num
	minerals_label.text = str(num_minerals)


func add_minerals(num):
	num_minerals += num
	minerals_label.text = str(num_minerals)


func activate_button(button):
	if button != null:
		var unit_button_ins = button.instantiate()
		var selected_unit = current_units[0]
		
		if unit_button_ins is Building:
			var unit_cost = unit_button_ins.cost
			
			if num_minerals > unit_cost:
				spend_minerals(unit_cost)
				selected_unit.create_structure(unit_button_ins)
		elif unit_button_ins is Unit:
			var unit_cost = unit_button_ins.cost
			if selected_unit.active:
				if num_minerals >= unit_cost and selected_unit.current_created_units != selected_unit.max_units_to_spawn:
					spend_minerals(unit_cost)
					selected_unit.add_unit_to_spawn(unit_button_ins)


### DEBUGGING ###

#func _on_plus_button_pressed():
	#add_minerals(100)


#func _on_minus_button_pressed():
	#spend_minerals(100)

### END DEBUGGING ###
