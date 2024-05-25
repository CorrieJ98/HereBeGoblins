class_name Unit extends RigidBody3D

const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.ENEMY : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}

enum UnitTeam{PLAYER,ENEMY,NEUTRAL}

@onready var selection_ring : MeshInstance3D = $SelectionRing
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@export var unit_team : UnitTeam
@export var unit_resource : PawnResource
var state_machine


func _ready():
	set_unit_colour()
	state_machine = animation_tree.get("parameters/playback")

func _process(delta):
	var target = nav_agent.get_next_path_position()
	var pos = get_global_transform().origin
	
	var normal = $RayCast3D.get_collision_normal()
	if normal.length_squared() < 0.001:
		normal = Vector3(0,1,0)
	
	# Rotate to move direction
	unit_resource.vel = (target - pos).slide(normal).normalized() * unit_resource.base_move_speed
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(unit_resource.vel.x, unit_resource.vel.z), delta * 10)
	
	$NavigationAgent3D.set_velocity(unit_resource.vel)


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
			unit_resource.current_state = unit_resource.States.IDLE
			unit_resource.move_speed = 0.00001
			unit_resource.state_machine.travel("Idle")
		"walking":
			unit_resource.current_state = unit_resource.States.IDLE
			unit_resource.current_move_speed = unit_resource.base_move_speed
			unit_resource.state_machine.travel("Walk")

func move_to(target_pos : Vector3):
	change_state("walking")
	
	# get the closest available point on the navmesh to the point that was clicked
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D.set_target_location(closest_pos)

func _on_navigation_agent_3d_target_reached():
	change_state("idle")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)
