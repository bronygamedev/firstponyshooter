extends Node3D

var enemy = load("res://Enemies/Basic/enemy.tscn")
var e_insence
var canSpawnNewEnemy = true
var navMapReady = false
@onready var map = $Map


func _ready():
	await get_tree().process_frame
	navMapReady = true

func _input(event):
	if event is InputEventKey and (event.keycode == KEY_T and canSpawnNewEnemy):
		e_insence = enemy.instantiate()
		e_insence.position = $EnemySpawn.position
		add_child(e_insence)
		$SpawnCoolDown.start()
		print("enemy spawn")
		canSpawnNewEnemy = false



func _on_cool_down_timeout():
	canSpawnNewEnemy = true


func _on_child_entered_tree(node):
	if node.is_in_group("Placeable_object") and navMapReady:
		map.bake_navigation_mesh(true)

