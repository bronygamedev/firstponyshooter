extends Node3D

var enemy = load("res://Scenes/misc/enemy.tscn")
var e_insence
var canSpawnNewEnemy = true
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
