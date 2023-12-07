extends CharacterBody3D

@export var mouse_sensitivity = 0.05 # (float , 0.01, 1)
@export var gamepad_sensitivity = 2 # (float , 0.01, 10)
@export var joystick_deadzone = 0.5 # (float , 0.01, 1)

@onready var head = $Head
@onready var ground_check = $GroundCheck
@onready var globalPlayerVars = get_node("/root/PlayerGlobalVarables")
@onready var globalVarables = get_node("/root/GlobalVarables")
@onready var sceneManager = get_node("/root/SceneManager")
@onready var gravity = globalVarables.gravity

var speed:float= 10
var h_acceleration:float = 6
var jump:float = 10
var air_acceleration:float = 1 
var normal_acceleration:float = 6


var full_contact:bool = false

var direction:Vector3
var h_velocity:Vector3
var movement:Vector3
var gravity_direction:Vector3

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$"HUD/HealthBar".value = globalPlayerVars.maxhealth

func _input(event):
	if event is InputEventMouseMotion and !get_tree().get_nodes_in_group("Settings")[0].visible:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-89),deg_to_rad(89))
		
func _physics_process(delta):
	gamepad_handler()
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
		gravity_direction += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_direction = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_direction = -get_floor_normal()
		h_acceleration = normal_acceleration
		
	if globalPlayerVars.health <= 0: 
		sceneManager.changeScene(owner.name, sceneManager.gameoverScreenPath)
		

	#movement
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
		gravity_direction = Vector3.UP * jump

	if Input.is_action_pressed("move_foward") or Input.is_action_pressed("joystick_Lstick_up"):
			direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward") or Input.is_action_pressed("joystick_Lstick_down"):
			direction += transform.basis.z
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("joystick_Lstick_left"):
			direction -= transform.basis.x
	elif Input.is_action_pressed("move_right") or Input.is_action_pressed("joystick_Lstick_right"):
			direction += transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.lerp(direction * speed,h_acceleration * delta)
	movement.z = h_velocity.z + gravity_direction.z
	movement.x = h_velocity.x + gravity_direction.x
	movement.y = gravity_direction.y
	set_velocity(movement)
	set_up_direction(Vector3.UP)
	move_and_slide()
	
func gamepad_handler():
	var rightstick = Input.get_vector("joystick_Rstick_right","joystick_Rstick_left","joystick_Rstick_down","joystick_Rstick_up", joystick_deadzone)
	if rightstick != Vector2.ZERO:
		rotate_y(deg_to_rad(rightstick.x * gamepad_sensitivity))
		head.rotate_x(deg_to_rad(rightstick.y * gamepad_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
		
func damage(_damage):
	globalPlayerVars.health -= _damage
	$"HUD/HealthBar".value = globalPlayerVars.health
