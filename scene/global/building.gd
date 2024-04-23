class_name Building extends Node

# All the below references are now found inside the relative profile

@export_category("Node References")
@export var sprite : Sprite2D
@export var portrait : Sprite2D
@export var collision_box : CollisionShape2D
@export var selection_box : CollisionShape2D
@export var selection_border : Panel
@export var is_selected : bool = false
@export var profile : Resource

func _ready():
	update_selection_border()

func get_anim_lib_string(lib : String, state, dir : Vector2i) -> String:
	# Create a full library path with str(lib) and add the
	# cardinal direction with str(dir)
	# example "beastmaster-anim-idle/NORTH"
	return (str(lib) + "-" + str(state) + "/" + str(dir))

func update_selection_border() -> void:
	profile.selection_border.visible = is_selected
