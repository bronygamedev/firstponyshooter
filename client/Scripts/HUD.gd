extends Control

@onready var globalPlayerVars = get_node("/root/PlayerGlobalVarables")
var settings = 1
func _input(event):
	if event.is_action_pressed("menu"):
		$SettingsContainer.visible = bool(settings)
		settings = not settings
		if !settings:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		

func _ready():
	$HealthBar.max_value = globalPlayerVars.maxhealth
	$HealthBar.value = globalPlayerVars.health
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthBar/Label.text = str($HealthBar.value)
