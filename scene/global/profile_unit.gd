class_name UnitProfile extends Ability

enum SpriteState {IDLE, MOVE, ATTACK}
enum UnitTeam {PLAYER, ALLY, ENEMY, NEUTRAL}
enum UnitType {
LABOURER,		# Can gather resources, build or work in buildings
SCOUT,			# Truesight, fast movespeed
ARCHER,			# standard ranged unit
INFANTRY,		# standard melee unit
MOUNTED,		# unit on horseback
}

@export_category("Basic")
@export var name: String
@export var rank := 1
@export var unit_type : UnitType


@export_category("Stats")
@export var max_health : int = 10
@export var current_health : int = 10
@export var speed_walk : int = 64
@export var base_atk_dmg : int = 2
@export var base_attack_speed : float = 2.0

@export_category("Behaviour")
@export var line_of_sight : int = 1000
@export var agro_range : int = 150

@export_category("Animations")
@export var library_name_idle: String
@export var library_name_move: String
@export var library_name_attack: String
@export var library_name_death: String
@export var library_names_corpse: Array[String]

# TODO Change to Ability class instead of String
@export_category("Abilities")
@export var tags: Array[Ability.UnitTags]

func get_library_from_state(sprite_state) -> String:
	match sprite_state:
		SpriteState.IDLE:
			return library_name_idle
		SpriteState.MOVE:
			return library_name_move
		SpriteState.ATTACK:
			return library_name_attack
	return "library name error"
