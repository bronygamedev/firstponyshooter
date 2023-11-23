extends Control


func _ready():
	$HealthBar.max_value = $"../healthManager".maxhealth
	$HealthBar.value = $"../healthManager".health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar/Label.text = str($HealthBar.value)
