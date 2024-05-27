class_name Unit extends RigidBody3D

const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.ENEMY : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}


enum States {IDLE, WALKING, ATTACKING, MINING, BUILDING}
var current_state = States.IDLE
var state_machine

@onready var selection_ring : MeshInstance3D = $SelectionRing
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

enum UnitTeam{PLAYER,ENEMY,NEUTRAL}
@export_category("Pawn Stats")
@export var unit_team : UnitTeam
@export var health : int
@export var atk_dmg : int
@export var atk_spd : float
@export var atk_rng : float
@export var move_speed : float = 100.0
@onready var base_move_speed : float = move_speed
var vel : Vector3
var normal

func _ready():
	set_unit_colour()
	state_machine = animation_tree.get("parameters/playback")
	move_speed = 0.0

func _physics_process(delta):
	var nav_target = nav_agent.get_next_path_position()
	var pos = get_global_transform().origin
	normal = $RayCast3D.get_collision_normal()
	
	# If the unit is in the air
	if normal.length_squared() < 0.001:
		normal = Vector3(0,1,0)
	
	# Rotate towards nav_target position
	vel = (nav_target - pos).slide(normal).normalized() * base_move_speed
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(vel.x, vel.z), delta * 10.0)
	nav_agent.set_velocity(vel)


func set_unit_colour() -> void:
	if unit_team in k_team_colours:
		selection_ring.material_override = k_team_colours[unit_team]

func select():
	selection_ring.visible = true

func deselect():
	selection_ring.visible = false

func change_state(state):
	match state:
		"idle":
			current_state = States.IDLE
			move_speed = 0.000001
			state_machine.travel("Idle")
		"walking":
			current_state = States.WALKING
			move_speed = base_move_speed
			state_machine.travel("Walk")

func move_to(target_pos : Vector3):
	change_state("walking")
	
	# get the closest available point on the navmesh to the point that was clicked
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	nav_agent.set_target_position(closest_pos)

func _on_navigation_agent_3d_target_reached():
	change_state("idle")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)
