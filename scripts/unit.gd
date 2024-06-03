class_name Unit extends RigidBody3D

@onready var animation_tree = $AnimationTree
@onready var unit_health_bar = $HealthBar/SubViewport/HealthProgressBar
@onready var rts_controller = get_tree().get_root().get_node("World/RTSController")
@onready var gui_controller = get_tree().get_root().get_node("World/CanvasLayer/GUIController")
@onready var nav_region = get_tree().get_root().get_node("World/NavigationRegion3D")

@onready var buildings_folder = get_tree().get_root().get_node("World/NavigationRegion3D/Buildings")
@onready var units_folder = get_tree().get_root().get_node("World/Units")


enum states { IDLE, WALKING, ATTACKING, MINING, BUILDING }
enum unit_types { WORKER, WARRIOR }

var speed : float
var vel : Vector3
var state_machine
var current_state = states.IDLE

var unit_type

var health : int = 100.0
var damage : int = 5
var cost : int = 50
var force_accel : int = 5
var unit_img = preload("res://assets/GUI/WorkerImg.jpg")

var team : int = 0
var team_colours : Dictionary = {
	0: preload("res://assets/Materials/TeamBlueMat.tres"),
	1: preload("res://assets/Materials/TeamRedMat.tres")
}


# Called when the node enters the scene tree for the first time.
func _ready():
	unit_health_bar.value = health
	state_machine = animation_tree.get("parameters/playback")
	speed = 0
	
	if team in team_colours:
		$SelectionRing.material_override = team_colours[team]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var target = $NavigationAgent3D.get_next_path_position()
	var pos = get_global_transform().origin
	var n = $RayCast3D.get_collision_normal()
	
	if n.length_squared() < 0.001:
		n = Vector3(0, 1, 0)
	
	vel = (target - pos).slide(n).normalized() * speed
	$Armature.rotation.y = lerp_angle($Armature.rotation.y, atan2(vel.x, vel.z), delta * 10)
	
	$NavigationAgent3D.set_velocity(vel)


func select():
	$SelectionRing.show()


func deselect():
	$SelectionRing.hide() 


func change_state(state):
	match state:
		"idle":
			current_state = states.IDLE
			state_machine.travel("Idle")
			speed = 0.000001
		"walking":
			current_state = states.WALKING
			state_machine.travel("Walk")
			speed = 2
		"attacking":
			current_state = states.ATTACKING
		"mining":
			current_state = states.MINING
		"building":
			current_state = states.BUILDING


func move_to(target_pos):
	var closest_pos = NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(), target_pos)
	change_state("walking")
	$NavigationAgent3D.set_target_position(closest_pos)


func _on_navigation_agent_3d_target_reached():
	change_state("idle")


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity)
