extends CharacterBody3D

var speed:float = 10 
var h_acceleration:float = 6
var gravity:float =  0#20
var jump:float = 10
var air_acceleration:float = 1
var normal_acceleration:float = 6

var full_contact:bool = false

@export var mouse_sensitivity = 0.05 # (float , 0.01, 1)
@export var gamepad_sensitivity = 1.5 # (float , 0.01, 10)
@export var joystick_deadzone = 0.5 # (float , 0.01, 1)

var direction:Vector3
var h_velocity:Vector3
var movment:Vector3
var gravity_direction:Vector3

@onready var skeleton = $Skeleton3D
@onready var ground_check = $GroundCheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	
	if event is InputEventMouseMotion:

		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var bone = skeleton.find_bone("Neck")
		var quat:Quaternion
		quat = Quaternion(Vector3(1,0,0),quat.y + (-event.relative.x * mouse_sensitivity))  # replace x, y, z, w with your values
#		var bone_pose = skeleton.get_bone_global_pose(bone)
#		bone_pose.basis = Basis(quat).orthonormalized()
		skeleton.set_bone_pose_rotation(16,quat)
#		skeleton.set_bone_global_pose_override(bone, bone_pose, 1.0, true)
		print(skeleton.get_bone_pose_rotation(16))
#		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
#		skeleton.set_bone_pose_rotation() clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))

func _physics_process(delta):
	
	direction = Vector3()
	gamepad_handler()
	
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
		
	# movement
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
			gravity_direction = Vector3.UP * jump
	
	if Input.is_action_pressed("move_foward"):
			direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
			direction += transform.basis.x
	
	direction = direction.normalized()
	h_velocity = h_velocity.lerp(direction * speed, h_acceleration * delta)
	movment.z = h_velocity.z + gravity_direction.z
	movment.x = h_velocity.x + gravity_direction.x
	movment.y = gravity_direction.y
	
	set_velocity(movment)
	set_up_direction(Vector3.UP)
	move_and_slide()
	
func gamepad_handler():
	var _leftstick = Input.get_vector("joystick_Lstick_right","joystick_Lstick_left","joystick_Lstick_down","joystick_Lstick_up", joystick_deadzone)
	var rightstick = Input.get_vector("joystick_Rstick_right","joystick_Rstick_left","joystick_Rstick_down","joystick_Rstick_up", joystick_deadzone)
	if rightstick != Vector2.ZERO:
		rotate_y(deg_to_rad(rightstick.x * gamepad_sensitivity))
#		head.rotate_x(deg_to_rad(rightstick.y * gamepad_sensitivity))
#		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
