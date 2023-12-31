<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# SceneManager.gd

**Extends:** [Node](../Node)

## Description

## Property Descriptions

### maptest

```gdscript
@export var maptest: String
```

### gameoverScreenPath

```gdscript
var gameoverScreenPath = "res://Scenes/menus/gameover.tscn"
```

### mainmenuScenePath

```gdscript
var mainmenuScenePath = "res://Scenes/menus/main_menu.tscn"
```

### args

```gdscript
var args: PackedStringArray
```

### installingmap

```gdscript
var installingmap: bool = false
```

## Method Descriptions

### changeScene

```gdscript
func changeScene(currentSceneName: String, newScenePath)
```

### installmap

```gdscript
func installmap(filepath: String, goToMap = false)
```

installs a `.fpsmap` map file. âš  unfinished âš