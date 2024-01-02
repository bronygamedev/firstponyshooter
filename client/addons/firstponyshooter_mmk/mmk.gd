@tool
extends Control
class_name fpsmmk_dock

var mapinfo
var map
var plugin = fpsmmk_plugin.new()
@onready var mapName = $ScrollContainer/HBoxContainer/Options/MapName
@onready var mapAuthor = $ScrollContainer/HBoxContainer/Options/AuthorName
@onready var mapVersion = $ScrollContainer/HBoxContainer/Options/MapVersion
@onready var maps = $ScrollContainer/HBoxContainer/Options/selector/OptionButton
@onready var gamePath = $ScrollContainer/HBoxContainer/FpsFilePath/LineEdit
@onready var godotPath = $ScrollContainer/HBoxContainer/GodotPath/LineEdit

func _ready():
	updateSelector()
	readConfig()

func _on_file_pressed():
	$ScrollContainer/HBoxContainer/FpsFilePath/FileDialog.visible = true
	
func _on_file_selected(path):
	$ScrollContainer/HBoxContainer/FpsFilePath/LineEdit.text = path

func _on_godot_file_dialog_file_selected(path):
	$ScrollContainer/HBoxContainer/GodotPath/LineEdit.text = path
	
func _on_Godotfile_pressed():
	$ScrollContainer/HBoxContainer/GodotPath/GodotFileDialog.visible = true

func _on_option_button_item_selected(index):
	map = maps.get_item_text(index)
	if map == "[select]":
		mapName.text = ""
		mapAuthor.text = ""
		mapVersion.text = ""
		return
	var f = FileAccess.open("res://Maps/" + map + "/map.json",FileAccess.READ)
	var jsonData = JSON.parse_string(f.get_as_text())
	mapName.text = jsonData.mapname
	mapAuthor.text = jsonData.mapauthor
	mapVersion.text = jsonData.mapversion

func _on_update_pressed():
	var f = FileAccess.open("res://Maps/" + map + "/map.json",FileAccess.READ)
	var jsonData = JSON.parse_string(f.get_as_text())

## Tests the curent selected map
func testMap():
	var err = buildMap()
	if err != OK:
		printerr("build FAILED")
		return
	if godotPath.text == null and gamePath.text == null:
		OS.execute(godotPath,["--main-pack", gamePath, "--args", "maptest",ProjectSettings.globalize_path("res://{0}.fpsmap".format([mapName.text]))])
	else:
		printerr("Paths not provided")

## Creats a map
func createMap() -> Error:
	var dir = DirAccess.open("res://Maps/")
	if (mapName.text != null and mapAuthor.text != null and mapVersion.text != null) and !dir.dir_exists(mapName.text):
		mapinfo = {
			mapname = mapName.text,
			mapauthor = mapAuthor.text,
			mapversion = mapVersion.text
		}
		dir.make_dir_recursive("res://Maps/" + mapName.text)
		var json_str = JSON.stringify(mapinfo)
		var file = FileAccess.open("res://Maps/{0}/map.json".format([mapName.text]), FileAccess.WRITE_READ)
		file.store_string(json_str)
		dir.copy_absolute(ProjectSettings.globalize_path("res://addons/firstponyshooter_mmk/templates/map.tscn"),ProjectSettings.globalize_path("res://Maps/" + mapName.text + "/map.tscn"))
		print("crated map base")
		return OK
	else:
		printerr("map already exists or insufficient data")
		return ERR_UNCONFIGURED

## builds the selected map
func buildMap() -> Error:
	if map == "[select]":
		printerr("No map seleted")
		return FAILED
	if !FileAccess.file_exists("res://Maps/{0}/preview.png".format([mapName.text])):
		printerr("No icon please add one")
		return ERR_UNCONFIGURED
	var mapPath : String = "res://Maps/" + mapName.text
	var writer := ZIPPacker.new()
	var err := writer.open(mapPath + ".fpsmap")
	if err != OK:
		print(err)
	for mapfile in DirAccess.get_files_at(mapPath):
		if mapfile.ends_with(".import") or mapfile.ends_with(".scn"):
			continue
		print("packing " + mapfile)
		var file = FileAccess.open(mapPath + "/" + mapfile,FileAccess.READ)
		if mapfile.ends_with(".tscn"):
			writer.start_file(mapfile.replace(".tscn",".scn"))
			var scene = load(mapPath + "/" + mapfile)
			var error = ResourceSaver.save(scene, mapPath + "/" + mapfile.replace(".tscn",".scn") )
			writer.write_file(FileAccess.get_file_as_bytes(mapPath + "/" + mapfile.replace(".tscn",".scn")))
		elif mapfile.ends_with(".png"):
			writer.start_file(mapfile)
			writer.write_file(FileAccess.get_file_as_bytes((mapPath + "/" + mapfile)))
		else:
			writer.start_file(mapfile)
			writer.write_file(file.get_as_text().replace("res://","user://").to_utf8_buffer())
		writer.close_file()
	writer.close()
	print("map built")
	return OK

## updates the map selector
func updateSelector():
	maps.clear()
	maps.add_item("[select]")
	var dirs = DirAccess.open("res://Maps/").get_directories()
	for d in dirs:
		var f = FileAccess.open("res://Maps/" + d + "/map.json",FileAccess.READ)
		var jsonData = JSON.parse_string(f.get_as_text())
		maps.add_item(jsonData.mapname)
## saves the game and godot path
func saveConfig():
	if (gamePath.text == null or godotPath.text == null)or (gamePath.text == "" or godotPath.text == ""):
		printerr("One or more paths are not set")
		return
	var configFile = FileAccess.open("res://config.json",FileAccess.WRITE)
	var config = {
		"fpsPath" = gamePath.text,
		"godotPath" = godotPath.text
	}
	var jsonString = JSON.stringify(config)
	configFile.store_string(jsonString)
	print("config saved")

## reads the config (if there is one) and sets the vaables
func readConfig():
	if !FileAccess.file_exists("res://config.json"):
		print("No config found")
		return
	var configFile = FileAccess.open("res://config.json",FileAccess.READ)
	var jsonString = JSON.parse_string(configFile.get_as_text())
	if jsonString.has("fpsPath"):
		gamePath.text = jsonString.fpsPath
	else:
		printerr("No game path found in config")
	if jsonString.has("godotPath"):
		godotPath.text = jsonString.godotPath
	else:
		printerr("No godot path found in config")


func _on_preview_button_pressed():
	if map == "[select]":
		printerr("No map seleted")
		return
	var trect = TextureRect.new()
	
	# scaling the image
	var image = plugin.take_screenshot()

	# Create a new ImageTexture object
	var image_texture = ImageTexture.new()

	# Create it from the Image you made earlier
	image_texture.create_from_image(image)

	# Assign it to the TextureRect Object
	trect.texture = image_texture
	# Define the scale factor
	var scale_factor = Vector2(0.3, 0.3) # Change this to your desired scale

	# Scale the image
	image.resize(image.get_width() * scale_factor.x, image.get_height() * scale_factor.y)

	# Define the export path
	var export_path = "res://Maps/{0}/preview.png".format([mapName.text])

	# Save the image as a .png file
	image.save_png(export_path)
	print("Preview created")


