extends Node

@export var  maptest:String
var gameoverScreenPath = "res://Scenes/menus/gameover.tscn"
var mainmenuScenePath = "res://Scenes/menus/main_menu.tscn"
var args : PackedStringArray
var userDir = DirAccess.open("user://")

func _enter_tree():
	if !userDir.dir_exists("Maps"):
		userDir.make_dir("user://Maps")
func _ready():
	args = OS.get_cmdline_args()
	var index = 0
	for arg in args:
		match arg:
			"maptest":
				installmap(args[index + 1],true)
				
		index += 1

func changeScene(currentSceneName:String, newScenePath):
	get_tree().root.add_child.call_deferred(load(newScenePath).instantiate())
	get_tree().root.get_node(currentSceneName).queue_free()
	return OK

## installs a `.fpsmap` map file.
func installmap(filepath:String,goToMap = false):
	var reader := ZIPReader.new()
	var err := reader.open(filepath)
	if err != OK:
		print("faild to load map error: " + str(err))
		return err
	var mapdata = JSON.parse_string(str(reader.read_file("map.json").get_string_from_utf8()))
	var mapname = mapdata.mapname
	print("installing " + mapname)
	var d = DirAccess.open("user://")
	d.make_dir_recursive("user://maps/" + mapname)
	for f in reader.get_files():
		print(f)
		var contents = reader.read_file(f)
		var mapfile = FileAccess.open("user://maps/" + mapname + "/"+ f,FileAccess.WRITE_READ)
		mapfile.store_buffer(contents)
		mapfile.close()
	reader.close()
	print("instalation complete")
	if goToMap:
		changeScene("Splash","user://maps/" + mapname + "/map.tscn")
	return OK
