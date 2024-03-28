class_name Unit extends CharacterBody2D

enum SpriteState {IDLE, MOVE, ATTACK}
enum UnitType {MELEE, RANGED, MECHANICAL}
enum UnitTeam {PLAYER, ALLY, ENEMY, NEUTRAL}

# Pointing toward
const DIRECTION = {
	"NORTH": Vector2(0, 1),
	"NORTHWEST": Vector2(-1, 1),
	"WEST": Vector2(-1, 0),
	"SOUTHWEST": Vector2(-1, -1),
	"SOUTH": Vector2(0, -1),
	"SOUTHEAST": Vector2(1, -1),
	"EAST": Vector2(1, 0),
	"NORTHEAST": Vector2(1, 1),
}

@onready var anim = $AnimationPlayer

@export var is_selected : bool = false
@export var sprite : Sprite2D
@export var selection_box : CollisionShape2D
@export var collision_box : CollisionShape2D
@export var unit_type: UnitType
@export var unit_team: UnitTeam
@export var profile : Profile

func _input(event) -> void:
	pass

func _physics_process(delta) -> void:
	var _dir = get_direction_of_travel()
	play_anim_from_lib("beastmaster-anim", SpriteState, _dir)

var vn : Vector2i = velocity.normalized()
func get_direction_of_travel() -> Vector2i:
	match vn:
		DIRECTION.NORTH:
			return DIRECTION.NORTH
		DIRECTION.NORTHEAST:
			return DIRECTION.NORTHEAST
		DIRECTION.EAST:
			return DIRECTION.EAST
		DIRECTION.SOUTHEAST:
			return DIRECTION.SOUTHEAST
		DIRECTION.SOUTH:
			return DIRECTION.SOUTH
		DIRECTION.SOUTHWEST:
			return DIRECTION.SOUTHWEST
		DIRECTION.WEST:
			return DIRECTION.WEST
		DIRECTION.NORTHWEST:
			return DIRECTION.NORTHWEST
		_:
			return vn

func play_anim_from_lib(lib : String, state, dir : Vector2i) -> void:
	# Create a full library path with str(lib) and add the
	# cardinal direction with str(dir)
	anim.play(str(lib) + "-" + str(state) + "/" + str(dir))
