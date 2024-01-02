@tool
extends EditorPlugin

class_name fpsmmk_plugin
# A class member to hold the dock during the plugin life cycle.
var dock
## screenshot button
var ssb 

func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the dock scene and instantiate it.
	dock = preload("res://addons/firstponyshooter_mmk/mmk.tscn").instantiate()
	# Add the loaded scene to the docks.
	add_control_to_dock(3, dock)
	# Note that LEFT_UL means the left of the editor, upper-left dock.

func take_screenshot() -> Image:
	# Get the editor camera and viewport
	var viewport = EditorInterface.get_editor_viewport_3d(0)
	var img = viewport.get_texture().get_image()
	return img
	


func _exit_tree():
	# Remove the dock.
	remove_control_from_docks(dock)
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,ssb)
	# Erase the control from the memory.
	dock.free()
