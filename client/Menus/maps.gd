extends ColorRect
## witch maps to load
enum loadType {
	ALL,
	BUILTIN,
	USER,
}
var mapThread:Thread
@onready var topRow = $ScrollContainer/Grid/Top
@onready var bottomRow = $ScrollContainer/Grid/Bottom

func _ready():
	loadMaps()
	
func loadMaps(type:loadType = loadType.ALL):
	var buildInMaps = DirAccess.open("res://Maps")
	var userMaps = DirAccess.open("user://Maps")
	@warning_ignore("unassigned_variable")
	var loadedmaps: Array[String]
	for child in topRow.get_children():
		loadedmaps.append(child.name)
	var mapLoader = func(loadtype:loadType):
		var path = "res"
		var lookDir:DirAccess = buildInMaps
		if loadtype == loadType.USER:
			path = "user"
			lookDir = userMaps
		for dir in lookDir.get_directories():
			print(dir)
			if loadedmaps.find(dir) != -1:
				print("map alredy loaded")
				continue
			var mapType = true
			if loadtype == loadType.USER:
				mapType = false
			var mapbutton = Button.new()
			var previewImage = Image.load_from_file("{0}://Maps/{1}/preview.png".format([path,dir]))
			mapbutton.icon = ImageTexture.create_from_image(previewImage)
			mapbutton.name = dir
			mapbutton.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
			mapbutton.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
			mapbutton.flat = true
			mapbutton.text = dir
			mapbutton.focus_mode = Control.FOCUS_NONE
			mapbutton.pressed.connect(_mapselected.bind(dir, mapType))
			var topRowChildrenCount = topRow.get_child_count()
			var bottomRowChildrenCount = bottomRow.get_child_count()
			if topRowChildrenCount <= bottomRowChildrenCount:
				topRow.add_child(mapbutton)
			else:
				bottomRow.add_child(mapbutton)
				
		print("added {0} maps".format([path.replace("res","built in")]))

	if type == loadType.ALL or type == loadType.BUILTIN:
		mapLoader.call(loadType.BUILTIN)
	if type == loadType.ALL or type == loadType.USER:
		mapLoader.call(loadType.USER)


func _mapselected(map,builtInMap):
	var basePath = "res://"
	var filePrefix = "tscn"
	if !builtInMap: 
		basePath = "user://"
		filePrefix = "scn"
	get_tree().change_scene_to_file("{0}Maps/{1}/map.{2}".format([basePath,map,filePrefix]))


func _on_install_map_pressed():
	$InstallMap/MapFileDialog.visible = true


func _on_map_file_dialog_file_selected(path):
	SceneManager.installmap(path)
	loadMaps(loadType.USER)
