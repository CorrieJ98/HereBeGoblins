class_name GameCharacter extends UnitConstructor

@export var unit_scene_import : PackedScene

@onready var t_appearance = unit_scene_import.apperance_resource
@onready var t_portrait = $"----- Spritesheets -----/Portrait"
@onready var t_spritesheets : Array[Sprite2D]

@onready var _arh = Appearance.AppearanceResourceHandler.new()

# TODO Dynamically create new Sprite2Ds for each spritesheet packed
# within the imported GameCharacter PackedScene. 

func _ready():
	draw_portrait()

func draw_portrait() -> void:
	t_portrait.texture = t_appearance.portrait
	_arh.vector_to_frame_data(t_appearance.portrait_frame_data, t_portrait.vframes,t_portrait.hframes)
