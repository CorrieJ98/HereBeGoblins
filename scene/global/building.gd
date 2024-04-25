class_name Building extends Node

# All the below references are now found inside the relative profile
@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var portrait = $Portrait
@onready var selection_box = $SelectionBorder
@onready var collision_box = $CollisionBox

@export var selection_border : Panel
@export var is_selected : bool = false

func _ready():
	pass
	#update_selection_border()

func get_anim_lib_string(lib : String, state, dir : Vector2i) -> String:
	# Create a full library path with str(lib) and add the
	# cardinal direction with str(dir)
	# example "beastmaster-anim-idle/NORTH"
	return (str(lib) + "-" + str(state) + "/" + str(dir))

#func update_selection_border() -> void:
	#profile.selection_border.visible = is_selected
