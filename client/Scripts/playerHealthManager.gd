extends Node3D

@onready var hud = $"../HUD"

const maxhealth = 100

var health = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		gameover() 

func gameover():
	hud.gameover()
