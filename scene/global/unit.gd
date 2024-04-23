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

var is_mouse_over : bool

func _ready():
	set_selected(is_selected)

# TODO Clicking to move
func _physics_process(delta) -> void:
	move_command(delta)
	move_and_slide()

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

func move_command(dt):
	pass

func attack_command():
	pass

func labour_command():
	pass

func on_mouse_hover() -> bool:
	is_mouse_over = true
	return is_mouse_over

func on_mouse_exited():
	is_mouse_over = false
	return is_mouse_over
