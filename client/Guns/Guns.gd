extends Node3D

var bullet = load("res://Objects/Bullets/Basic/bullet.tscn")
var instance
var aiming = false

@onready var gun_anim = $"Type-a/AnimationPlayer"
@onready var gun_barrel = $"Type-a/RayCast3D"
func _ready():
	print(owner.name)

func _process(_delta):
	if Input.is_action_pressed("shoot") and !get_tree().get_nodes_in_group("Settings")[0].visible:
		shoot()
	#if Input.is_action_pressed("aim"):
		#if not aiming:
			#$"../../../AnimationPlayer".play("aim")
			#aiming = true
	#elif Input.is_action_just_released("aim"):
		#$"../../../AnimationPlayer".play_backwards("aim")
		#aiming = false


func shoot():
	if !gun_anim.is_playing():
		gun_anim.play("Shoot")
		instance = bullet.instantiate()
		instance.position = gun_barrel.global_position
		instance.transform.basis = gun_barrel.global_transform.basis
		owner.get_parent().add_child(instance)
