extends CharacterBody3D

var speed:float = 10 
var h_acceleration:float = 6
var jump:float = 10
var air_acceleration:float = 1
var normal_acceleration:float = 6
var VERTICAL_sensitivity = .005
var angle := 0.0
var full_contact:bool = false

@export var mouse_sensitivity = 0.05 # (float , 0.01, 1)
@export var gamepad_sensitivity = 1.5 # (float , 0.01, 10)
@export var joystick_deadzone = 0.5 # (float , 0.01, 1)

var direction:Vector3
var h_velocity:Vector3
var movement:Vector3
var gravity_direction:Vector3

@onready var skel = $Skeleton3D
@onready var ground_check = $GroundCheck
@onready var globalPlayerVars = get_node("/root/PlayerGlobalVarables")
@onready var globalVarables = get_node("/root/GlobalVarables")
@onready var sceneManager = get_node("/root/SceneManager")
@onready var gravity = globalVarables.gravity

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		# Get the current pose of the bone
		var bonePose = skel.get_bone_global_pose(17)
		# Save the original position
		var original_position = bonePose.origin
		# Define the rotation axis as the X axis
		var axis = Vector3(1, 0, 0)
		# Define the rotation angle based on relative.x
		angle = event.relative.y * mouse_sensitivity * VERTICAL_sensitivity
		# Apply the rotation to the pose
		bonePose = bonePose.rotated(axis, angle)
		# Reset the position to the original one
		bonePose.origin = original_position
		# Set the new pose of the bone
		skel.set_bone_global_pose_override(17, bonePose, 1.0, true)

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
			direction += transform.basis.z
	elif Input.is_action_pressed("move_backward") or Input.is_action_pressed("joystick_Lstick_down"):
			direction -= transform.basis.z
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("joystick_Lstick_left"):
			direction += transform.basis.x
	elif Input.is_action_pressed("move_right") or Input.is_action_pressed("joystick_Lstick_right"):
			direction -= transform.basis.x
		
	direction = direction.normalized()
	h_velocity = h_velocity.lerp(direction * speed,h_acceleration * delta)
	movement.z = h_velocity.z + gravity_direction.z
	movement.x = h_velocity.x + gravity_direction.x
	movement.y = gravity_direction.y
	set_velocity(movement)
	set_up_direction(Vector3.UP)
	move_and_slide()
	
func gamepad_handler():
	var _leftstick = Input.get_vector("joystick_Lstick_right","joystick_Lstick_left","joystick_Lstick_down","joystick_Lstick_up", joystick_deadzone)
	var rightstick = Input.get_vector("joystick_Rstick_right","joystick_Rstick_left","joystick_Rstick_down","joystick_Rstick_up", joystick_deadzone)
	if rightstick != Vector2.ZERO:
		rotate_y(deg_to_rad(rightstick.x * gamepad_sensitivity))
		# Get the current pose of the bone
		var bonePose = skel.get_bone_global_pose(17)
		# Define the rotation axis as the X axis
		var axis = Vector3(1, 0, 0)
		# Define the rotation angle based on relative.x
		angle = -rightstick.y * mouse_sensitivity
		# Apply the rotation to the pose
		bonePose = bonePose.rotated(axis, angle)
		# Set the new pose of the bone
		skel.set_bone_global_pose_override(17, bonePose, 1.0, true)
#		head.rotate_x(deg_to_rad(rightstick.y * gamepad_sensitivity))
#		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
