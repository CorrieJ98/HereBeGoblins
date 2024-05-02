class_name GameCharacter extends UnitConstructor

@export var unit_scene_import : PackedScene

#temporary
@export var spritesheet_number : int = 0

@onready var t_portrait = $"----- Spritesheets -----/Portrait"
@onready var t_base_sprite = $"----- Spritesheets -----/----- Dynamic -----/Base"
var t_appearance	# See _ready()

# Dynamic Spritesheet Directory
const dss_dir = String("./----- Spritesheets -----/----- Dynamic -----")


# Class constructors
@onready var _arh = Appearance.AppearanceResourceHandler.new()

# TODO Dynamically create new Sprite2Ds for each spritesheet packed
# within the imported GameCharacter PackedScene. 

func _ready():
	t_appearance = get_appearance_resource()
	packed_scene_import_debug_check()
	draw_portrait()
	draw_base_sprite(spritesheet_number)

func packed_scene_import_debug_check() -> void:
	if unit_scene_import != PackedScene:
		print("building scene imported successfully")
	else:
		print("building scene not imported, something went wrong!")

func get_appearance_resource():
	var a
	a = unit_scene_import._bundled.values().find("appearance_resource")
	return a[a]

func draw_portrait() -> void:
	t_portrait.texture = t_appearance.portrait
	_arh.vector_to_frame_data(t_appearance.portrait_frame_data, t_portrait.vframes,t_portrait.hframes)

func draw_base_sprite(spritesheet_number : int) -> void:
	t_base_sprite.texture = t_appearance.body_spritesheets[spritesheet_number]
	_arh.vector_to_frame_data(t_appearance.body_spritesheets_frame_data[spritesheet_number],t_base_sprite.vframes,t_base_sprite.hframes)

func get_dynamic_spritesheets() -> Array[Sprite2D]:
	var children : Array[Sprite2D]
	
	# Dirty typecasting because I know best
	children = get_node(dss_dir).get_children(false) as Array[Sprite2D]
	return children

func _on_base_frame_changed():
	for each in t_base_sprite.get_children():
		each.frame = t_base_sprite.frame

func _on_base_texture_changed():
	pass
	# each texture ITERATOR within the texture arrays in appearance
	#for each in t_base_sprite.get_children():
		#each.texture = t_base_sprite.frame
