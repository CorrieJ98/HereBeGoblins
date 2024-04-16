class_name Unit extends CharacterBody2D

enum SpriteState {IDLE, MOVE, ATTACK}
enum UnitTeam {PLAYER, ALLY, ENEMY, NEUTRAL}

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var portrait = $Portrait
@onready var selection_box = $SelectionBorder
@onready var collision_box = $CollisionBox

@export var selection_border : Panel
@export var is_selected : bool = false

@export var unit_team : UnitTeam
@export var profile : UnitProfile

func _ready():
	set_selected(is_selected)

func _physics_process(delta) -> void:
	pass

func get_anim_string(lib : String, state, dir : Vector2i) -> String:
	# Create a full library path with str(lib) and add the
	# cardinal direction with str(dir)
	# example "beastmaster-anim-idle/NORTH"
	return (str(lib) + "-" + str(state) + "/" + str(dir))

func set_selected(selection : bool):
	selection_border.visible = selection

func get_selection_objects(box : Panel, border : Panel) -> void:
	box = selection_box
	border = selection_border
	
