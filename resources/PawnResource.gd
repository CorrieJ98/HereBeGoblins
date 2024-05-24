class_name PawnResource extends UnitResourceAutoLoad

enum PawnSubtypes {INFANTRY, ARCHER, WORKER}
enum States {IDLE, WALKING, MINING, BUILDING, ATTACKING}

@export_category("Basic Pawn Properties")
@export var name : String
@export_multiline var description : String
@export var health : int
@export var subtype : PawnSubtypes

@export_category("Pawn Stats")
@export var base_move_speed : float
@export var atk_dmg : int
@export var atk_spd : float
@export var atk_rng : float

var vel : Vector3
var state_machine
var current_state = States.IDLE
var current_move_speed : float = base_move_speed
