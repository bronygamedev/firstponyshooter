
extends Control

var settings_vis = 1

func _input(event):
	if event.is_action_pressed("menu"):
		$SettingsContainer.visible = bool(settings_vis)
		settings_vis = not settings_vis
		if !settings_vis:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(_delta):
	$HealthBar/Label.text = str($HealthBar.value)


func _on_settings_container_exit():
	$SettingsContainer.visible = bool(settings_vis)
	settings_vis = not settings_vis
	if !settings_vis:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
