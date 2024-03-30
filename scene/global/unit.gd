class_name Unit extends CharacterBody2D

enum SpriteState {IDLE, MOVE, ATTACK}
enum UnitType {MELEE, RANGED, MECHANICAL}
enum UnitClass {WORKER, SCOUT, SUPPORT, LIGHT, HEAVY, HERO}
enum UnitTeam {PLAYER, ALLY, ENEMY, NEUTRAL}

@onready var anim = $AnimationPlayer

@export var sprite : Sprite2D
@export var portrait : Sprite2D
@export var selection_box : CollisionShape2D
@export var selection_border : Panel
@export var collision_box : CollisionShape2D
@export var unit_type: UnitType
@export var unit_team: UnitTeam
@export var unit_class: UnitClass
@export var profile : UnitProfile

func _physics_process(delta) -> void:
	pass

func get_anim_string(lib : String, state, dir : Vector2i) -> String:
	# Create a full library path with str(lib) and add the
	# cardinal direction with str(dir)
	# example "beastmaster-anim-idle/NORTH"
	return (str(lib) + "-" + str(state) + "/" + str(dir))
