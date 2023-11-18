extends CharacterBody3D

var speed = 2
var accel = 10
var gravity = -10
var navMapReady = false

@export var health = 2
@onready var nav := $NavigationAgent3D

func _ready():
	# Delay navigation queries until after the first physics frame
	await get_tree().process_frame
	navMapReady = true


func _physics_process(delta):
	
	if health <= 0:
		queue_free()
	var direction = Vector3.ZERO
	if navMapReady:
		nav.target_position = $"../Player".global_position
		
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		
		velocity = velocity.lerp(direction * speed, accel * delta)
		if not is_on_floor():
			velocity.y += gravity
	move_and_slide()
