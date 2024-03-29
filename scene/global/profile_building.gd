class_name BuildingProfile extends Ability

@export var name: String
@export var tier := 1

@export_category("Stats")
@export var max_health : int = 1000
@export var current_health : int = 1000
@export var base_atk_dmg : int = 7
@export var base_attack_speed : float = 0.5

@export_category("Behaviour")
@export var line_of_sight : int = 2048
@export var agro_range : int = 0

@export_category("Animations")
@export var library_name_attack: String
@export var library_name_damage: String
@export var library_name_death : String
@export var library_name_working : String
@export var library_names_idle: Array[String]
@export var library_names_destroyed: Array[String]

@export_category("Abilities")
@export var basic_abilties: Array[Ability.BuildingBasicAbilities]
@export var special_abilities: Array[Ability.BuildingSpecialAbilities]
@export var traits: Array[Ability.BuildingTraits]
