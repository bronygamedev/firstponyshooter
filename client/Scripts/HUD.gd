extends Control

@onready var globalPlayerVars = get_node("/root/PlayerGlobalVarables")

var settings_vis = 1

func _input(event):
	if event.is_action_pressed("menu"):
		$SettingsContainer.visible = bool(settings_vis)
		settings_vis = not settings_vis
		if !settings_vis:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready():
	$HealthBar.max_value = globalPlayerVars.maxhealth
	$HealthBar.value = globalPlayerVars.health

func _process(delta):
	$HealthBar/Label.text = str($HealthBar.value)


func _on_settings_container_exit():
	$SettingsContainer.visible = bool(settings_vis)
	settings_vis = not settings_vis
	if !settings_vis:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
