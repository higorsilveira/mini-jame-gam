extends Node2D

@export var box_explosive_scene: PackedScene
@export var box_common_scene: PackedScene

@export var spawn_interval: float = 2.0

@export_range(0.0, 1.0) var explosive_chance: float = 0.3

@onready var top_left: Marker2D = $TopLeft
@onready var bottom_right: Marker2D = $BottomRight
@onready var spawn_timer: Timer = $SpawnTimer
@onready var area_2d: StaticBody2D = $Area2D

var rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	area_2d.add_to_group("world")
	rng.randomize()
	
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.start()


func _get_random_position_in_area() -> Vector2:
	var p1: Vector2 = top_left.global_position
	var p2: Vector2 = bottom_right.global_position

	var min_x: float = p1.x if p1.x < p2.x else p2.x
	var max_x: float = p1.x if p1.x > p2.x else p2.x
	var min_y: float = p1.y if p1.y < p2.y else p2.y
	var max_y: float = p1.y if p1.y > p2.y else p2.y

	var x: float = rng.randf_range(min_x, max_x)
	var y: float = rng.randf_range(min_y, max_y)

	return Vector2(x, y)


func spawn_explosive_box() -> void:
	if box_explosive_scene == null:
		return
	
	var box: Node2D = box_explosive_scene.instantiate()
	box.global_position = _get_random_position_in_area()
	
	get_parent().add_child(box)


func spawn_common_box() -> void:
	if box_common_scene == null:
		return
	
	var box: Node2D = box_common_scene.instantiate()
	box.global_position = _get_random_position_in_area()
	get_parent().add_child(box)


func spawn_random_boxes(explosive_count: int, common_count: int) -> void:
	for i in range(explosive_count):
		spawn_explosive_box()
	for i in range(common_count):
		spawn_common_box()

func _on_spawn_timer_timeout() -> void:
	if GameController.gameFinished:
		return 
	var roll: float = rng.randf()
	if roll < explosive_chance:
		spawn_explosive_box()
	else:
		spawn_common_box()
