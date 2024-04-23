class_name BuildingProfile extends Ability

enum SpriteState {IDLE, WORKING}
enum BuildingTeam {PLAYER, ALLY, ENEMY, NEUTRAL}

enum BuildingType {
TOWNHALL,		# Unique; Spawns LABOURER type;
BARRACKS, 		# Spawns LIGHTINFANTRY & HEAVYINFANTRY;
STABLES, 		# Spawns mounted units
FORGE,			# Upgrades units
WORKSHOP,		# Spawns flying & siege units
WATCHTOWER		# Truesight, can attack
}

@export var spritesheet : Sprite2D
var portrait : Sprite2D
var anim_player : AnimationPlayer
var selection_box : CollisionShape2D
var collision_box : CollisionShape2D
var selection_border : Panel

func _ready():
	spritesheet = Sprite2D.new()

@export_category("Basic")
@export var name: String
@export var team : BuildingTeam
@export var tier : int = 1
@export var building_type : BuildingType


@export_category("Stats")
@export var max_health : int = 1000
@export var current_health : int = 1000
@export var base_atk_dmg : int = 7
@export var base_attack_speed : float = 0.5

@export_category("Behaviour")
@export var line_of_sight : int = 2048
@export var agro_range : int = 0
@export var max_embarked_units : int
@export var embarked_units : int

@export_category("Animations")
@export var library_name_attack: String
@export var library_name_damage: String
@export var library_name_death : String
@export var library_name_working : String
@export var library_names_idle: Array[String]
@export var library_names_destroyed: Array[String]

@export_category("Abilities")
@export var building_tags : Array[Ability.BuildingTags]
