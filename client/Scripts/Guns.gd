extends Node3D

var bullet = load("res://Scenes/misc/bullet.tscn")
var bullet_insence
var aiming = false

@onready var gun = $"Type-a"
@onready var gun_animation = $"Type-a/AnimationPlayer"
@onready var gun_barrel = $"Type-a/Barrel"

func _process(_delta):
	if Input.is_action_pressed("shoot"):
		if !gun_animation.is_playing():
			gun_animation.play("Shoot")
			bullet_insence = bullet.instantiate()
			bullet_insence.damage = gun.get_meta("damage")
			bullet_insence.position = gun_barrel.global_position
			bullet_insence.transform.basis = gun_barrel.global_transform.basis
			get_parent().get_parent().get_parent().add_child(bullet_insence)
	if Input.is_action_pressed("aim"):
		if not aiming:
			$"../../AnimationPlayer".play("aim")
			aiming = true
			$"../..".mouse_sensitivity = 0.01
	elif Input.is_action_just_released("aim"):
		$"../../AnimationPlayer".play_backwards("aim")
		aiming = false
		$"../..".mouse_sensitivity = 0.05
		
