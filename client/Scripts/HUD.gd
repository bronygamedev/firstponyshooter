extends Control

@onready var globalPlayerVars = get_node("/root/PlayerGlobalVarables")


func _ready():
	$HealthBar.max_value = globalPlayerVars.maxhealth
	$HealthBar.value = globalPlayerVars.health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar/Label.text = str($HealthBar.value)
