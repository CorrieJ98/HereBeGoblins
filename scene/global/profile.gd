class_name Profile extends Resource

@export var name: String
@export var rank := 1

@export_category("Stats")
@export var max_health : int = 10
@export var current_health : int = 10
@export var speed_walk : int = 64
@export var base_atk_dmg : int = 2
@export var base_attack_speed : float = 2.0

@export_category("Behaviour")
@export var line_of_sight : int = 1024
@export var agro_range : int = 128

@export_category("Animations")
@export var library_name_idle: String
@export var library_name_move: String
@export var library_name_attack: String
@export var library_name_death: String
@export var library_names_corpse: Array[String]

func get_library_from_state(sprite_state) -> String:
	match sprite_state:
		Unit.SpriteState.IDLE:
			return library_name_idle
		Unit.SpriteState.MOVE:
			return library_name_move
		Unit.SpriteState.ATTACK:
			return library_name_attack
	return "library name error"
