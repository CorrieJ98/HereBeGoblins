class_name PawnResource extends UnitResourceAutoLoad

enum PawnSubtypes {INFANTRY, ARCHER, WORKER}

@export_category("Basic Pawn Properties")
@export var name : String
@export_multiline var description : String
@export var health : int
@export var subtype : PawnSubtypes

@export_category("Pawn Stats")
@export var move_speed : float
@export var atk_dmg : int
@export var atk_spd : float
@export var is_melee : bool

@export_category("Pawn Advanced Stats")
@export var agro_radius : float
@export var atk_rng : float
@export var mesh : PackedScene
