class_name Building extends Node

enum SpriteState {IDLE, WORKING}
enum BuildingType {TOWNHALL,BARRACKS, STABLES, FORGE, WORKSHOP, WATCHTOWER}
enum BuildingTeam {PLAYER, ALLY, ENEMY, NEUTRAL}

@onready var anim = $AnimationPlayer

@export var sprite : Sprite2D
@export var portrait : Sprite2D
@export var selection_box : CollisionShape2D
@export var selection_border : Panel
@export var collision_box : CollisionShape2D
@export var building_type: BuildingType
@export var building_team : BuildingTeam
@export var profile : BuildingProfile

func get_anim_lib_string(lib : String, state, dir : Vector2i) -> String:
	# Create a full library path with str(lib) and add the
	# cardinal direction with str(dir)
	# example "beastmaster-anim-idle/NORTH"
	return (str(lib) + "-" + str(state) + "/" + str(dir))
