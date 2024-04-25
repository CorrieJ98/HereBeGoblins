class_name GameBuilding extends BuildingConstructor

@export var building_scene_import : PackedScene

@onready var t_portrait = $"----- Spritesheets -----/Portrait"
@onready var t_spritesheets : Array[Sprite2D]
var t_appearance 

@onready var _arh = Appearance.AppearanceResourceHandler.new()

# TODO Dynamically create new Sprite2Ds for each spritesheet packed
# within the imported GameBuilding PackedScene. 

func _ready():
	draw_portrait()
	t_appearance = get_appearance_resource()

func get_appearance_resource():
	var a
	a = building_scene_import._bundled.find_key("appearance_resource")
	if a == null:
		print("THIS IS STILL FUCKED")
	return a

func draw_portrait() -> void:
	t_portrait.texture = t_appearance.portrait
	_arh.vector_to_frame_data(t_appearance.portrait_frame_data, t_portrait.vframes,t_portrait.hframes)
