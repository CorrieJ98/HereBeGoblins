extends Node2D

@export var ang_acc = 1
@export var MAX_ANG_SPEED = 50
@export var low = -0.2
@export var high = 0.8
@export var MOUSE_SENSITIVITY = 5.0

var angu = 1
var angd = -1

func _ready():
	set_process(true)	

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		

	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.x = clamp(rotation.x,-0.2,0.8)
		rotate_x(event.relative.y * MOUSE_SENSITIVITY)
		print(rotation.x)

func _process(delta):
	if Input.is_key_pressed(KEY_R):
		if rotation.x <= (high):	
			angd += ang_acc * delta			
			angd = clamp(angd,0,MAX_ANG_SPEED)
			rotate_x(angd*delta)
			print(rotation.x)
			
	
	elif Input.is_key_pressed(KEY_F):
		if rotation.x >= (low):
			angu += ang_acc * delta
			angu = clamp(angu,0,MAX_ANG_SPEED)
			rotate_x(-angu*delta)
			print(rotation.x)

	else:
		angu = 0
		angd = 0
