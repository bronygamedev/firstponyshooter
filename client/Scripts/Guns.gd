extends Node3D

var bullet = load("res://Scenes/misc/bullet.tscn")
var instance
var aiming = false

@onready var gun_anim = $"Type-a/AnimationPlayer"
@onready var gun_barrel = $"Type-a/RayCast3D"
#@onready var gun_anim2 =
#@onready var gun_barrel2 =

func _ready():
	print(owner.name)

func _process(_delta):
	if Input.is_action_pressed("shoot") and !get_tree().get_nodes_in_group("Settings")[0].visible:
		shoot()
	if Input.is_action_pressed("aim"):
		if not aiming:
			$"../../../AnimationPlayer".play("aim")
			aiming = true
			#$"../..".mouse_sensitivity = 0.01
	elif Input.is_action_just_released("aim"):
		$"../../../AnimationPlayer".play_backwards("aim")
		aiming = false
		#$"../..".mouse_sensitivity = 0.05

func shoot():
	if !gun_anim.is_playing():
		gun_anim.play("Shoot")
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		owner.get_parent().add_child(instance)
