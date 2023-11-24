extends Node

var gameoverScreenPath = "res://Scenes/menus/gameover.tscn"
var mainmenuScenePath = "res://Scenes/menus/main_menu.tscn"


func changeScene(currentSceneName:String, newScenePath):
	get_tree().root.add_child(load(newScenePath).instantiate())
	get_tree().root.get_node(currentSceneName).queue_free()
