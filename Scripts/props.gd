extends Node2D

@export var prop_scenes: Array[PackedScene] 

func _ready() -> void:
	_spawn_props()


func _spawn_props() -> void:
	for marker in get_children():
		if marker is Marker2D:

			var scene: PackedScene = prop_scenes.pick_random()

			var prop: Node2D = scene.instantiate()

			prop.global_position = marker.global_position  

			add_child(prop)
