class_name Unit extends RigidBody3D

const k_team_colours : Dictionary = {
	UnitTeam.PLAYER : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamBlueMat.tres"),
	UnitTeam.ENEMY : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamRedMat.tres"),
	UnitTeam.NEUTRAL : preload("res://assets/Udemy-AvivDavid/Project Assets/Materials/TeamNeutMat.tres")
}

enum UnitTeam{PLAYER,ENEMY,NEUTRAL}

@onready var selection_ring : MeshInstance3D = $SelectionRing

@export var unit_team : UnitTeam
@export var unit_resource : PawnResource

#  NOTE TO SELF
# EP10 @ 8:29 Udemy - Unit Movement tutorial
# Add raycast to the worker - everything before he changes scripts is done and squared away. Happy coding <3

func _ready():
	set_unit_colour()

func _process(delta):
	var target = $NavigationAgent3D.get_next_location()
	var pos = get_global_transform().origin

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
			unit_resource.state_machine.travel("idle")
		"walking":
			unit_resource.current_state = unit_resource.States.IDLE
			unit_resource.current_move_speed = unit_resource.base_move_speed
			unit_resource.state_machine.travel("walk")

func move_to(target_pos : Vector3):
	change_state("walking")
	
	# get the closest available point on the navmesh to the point that was clicked
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	$NavigationAgent3D.set_target_location(closest_pos)

func _on_navigation_agent_3d_target_reached():
	change_state("idle")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)
