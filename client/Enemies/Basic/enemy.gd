extends CharacterBody3D

var speed = 2
var accel = 10
var gravity = -10
var navMapReady = false
var playerRange = 10
var bullet = load("res://Objects/Bullets/Basic/bullet.tscn")
var bullet_insence

@export var health = 2

@onready var nav := $NavigationAgent3D
@onready var gun = $"Type-a"
@onready var gun_animation = $"Type-a/AnimationPlayer"
@onready var gun_barrel = $"Type-a/RayCast3D"

func _ready():
	# Delay navigation queries until after the first physics frame
	await get_tree().process_frame
	navMapReady = true

func _physics_process(delta):
	look_at($"../Player".global_position)
	if health <= 0:
		queue_free()
	var direction = Vector3.ZERO
	path_finding(direction,delta)
	if is_point_in_radius(global_position,$"../Player".global_position,playerRange):
		$"Type-a".look_at($"../Player".global_position)
		shoot()
	move_and_slide()

func path_finding(direction:Vector3, delta):
	if navMapReady:
		nav.target_position = $"../Player".global_position
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
		if not is_on_floor():
			velocity.y += gravity

func is_point_in_radius(center: Vector3, point: Vector3, radius: float) -> bool:
	var distance = center.distance_to(point)
	return distance <= radius

func shoot():
	if !gun_animation.is_playing():
		gun_animation.play("Shoot")
		bullet_insence = bullet.instantiate()
		bullet_insence.damage = gun.get_meta("damage")
		bullet_insence.position = gun_barrel.global_position
		bullet_insence.transform.basis = gun_barrel.global_transform.basis
		bullet_insence.shotfrom = bullet_insence.shotspawners.Enemy
		get_parent().get_parent().add_child(bullet_insence)
