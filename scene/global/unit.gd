class_name Unit extends CharacterBody2D

enum SpriteState {IDLE, MOVE, ATTACK}
enum UnitType {MELEE, RANGED, MECHANICAL}
enum UnitTeam {PLAYER, ALLY, ENEMY, NEUTRAL}

# DIRECTIONS ARE TAKEN TO BE POINTING INTO THE FACE
const FACES = {
	"SOUTH": Vector2(0, 1),
	"SOUTHWEST": Vector2(-1, 1),
	"WEST": Vector2(-1, 0),
	"NORTHWEST": Vector2(-1, -1),
	"NORTH": Vector2(0, -1),
	"NORTHEAST": Vector2(1, -1),
	"EAST": Vector2(1, 0),
	"SOUTHEAST": Vector2(1, 1),
}

@onready var box = $Panel
@onready var target = position

var follow_cursor : bool = false

@export var is_selected : bool = false
@export var sprite : Sprite2D
@export var anim : AnimationPlayer
@export var selection_box : CollisionShape2D
@export var collision_box : CollisionShape2D
@export var unit_type: UnitType
@export var unit_team: UnitTeam
@export var profile : Profile

func _ready():
	set_selected(is_selected)

func set_selected(is_selection : bool):
	box.visible = is_selection

func _input(event):
	if event.is_action_just_pressed("RightClick"):
		follow_cursor = true
	if event.is_action_released("RightClick"):
		follow_cursor = false

func _physics_process(delta):
	if follow_cursor:
		if is_selected:
			target = get_global_mouse_position()
	velocity = position.direction_to(target) * profile.speed_walk
	if position.distance_to(target) > 1.0:
		move_and_slide()
	else:
		pass
