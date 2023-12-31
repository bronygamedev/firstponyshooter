<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# enemy.gd

**Extends:** [CharacterBody3D](../CharacterBody3D)

## Description

## Property Descriptions

### speed

```gdscript
var speed = 2
```

### accel

```gdscript
var accel = 10
```

### gravity

```gdscript
var gravity = -10
```

### navMapReady

```gdscript
var navMapReady = false
```

### range

```gdscript
var range = 10
```

### bullet

```gdscript
var bullet
```

### bullet\_insence

```gdscript
var bullet_insence
```

### health

```gdscript
@export var health = 2
```

### nav

```gdscript
var nav: Node
```

### gun

```gdscript
var gun
```

### gun\_animation

```gdscript
var gun_animation
```

### gun\_barrel

```gdscript
var gun_barrel
```

## Method Descriptions

### path\_finding

```gdscript
func path_finding(direction: Vector3, delta)
```

### is\_point\_in\_radius

```gdscript
func is_point_in_radius(center: Vector3, point: Vector3, radius: float) -> bool
```

### shoot

```gdscript
func shoot()
```

