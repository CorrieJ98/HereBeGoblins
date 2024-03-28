class_name Unit extends CharacterBody2D

enum SpriteState {IDLE, MOVE, ATTACK}
enum UnitType {MELEE, RANGED, MECHANICAL}
enum UnitTeam{PLAYER, ALLY, ENEMY, NEUTRAL}

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

@export var sprite : Sprite2D
@export var anim : AnimationPlayer
@export var selection_box : CollisionShape2D
@export var collision_box : CollisionShape2D
@export var unit_type: UnitType
@export var unit_team: UnitTeam
@export var profile : Profile
