extends KinematicBody

var speed = 10 
var h_acceleration = 6
var gravity = 20
var jump = 10
var Full_contact = false
var air_acceleration = 1
var normal_acceleration = 6

export(float , 0.01, 1) var mouse_sencitivity = 0.05

var direction:Vector3
var h_velocity:Vector3
var movment:Vector3
var gravity_vec:Vector3

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sencitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sencitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89),deg2rad(89))
	
	if event is InputEventKey:
		print(is_on_floor())
		
		

func _physics_process(delta):
	
	direction = Vector3()
	
	if ground_check.is_colliding():
		Full_contact = true
	else:
		Full_contact = false
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and Full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
			gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("move_foward"):
			direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
			direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
			direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
			direction += transform.basis.x
	
	direction = direction.normalized()
	h_velocity = h_velocity.linear_interpolate(direction * speed, h_acceleration * delta)
	movment.z = h_velocity.z + gravity_vec.z
	movment.x = h_velocity.x + gravity_vec.x
	movment.y = gravity_vec.y
	
	move_and_slide(movment, Vector3.UP)
