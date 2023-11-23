extends Node3D


const maxhealth = 100

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func damage(_damage):
	health -= _damage
	$"../HUD/HealthBar".value = health
