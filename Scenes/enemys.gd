extends Node2D

@export var enemy_1: PackedScene
@onready var marker_top_left_out: Marker2D = $MarkerTopLeftOut
@onready var marker_top_left_in: Marker2D = $MarkerTopLeftIn
@onready var marker_bot_right_in: Marker2D = $MarkerBotRightIn
@onready var marker_bot_right_out: Marker2D = $MarkerBotRightOut

const qtdEnemies = 100
var listEnemies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_1 == null:
		return

	for i in qtdEnemies:
		var new_enemy = enemy_1.instantiate()
		listEnemies.append(new_enemy)
		add_child(new_enemy)
		new_enemy.position = rand_pos_in_spawn_area()

func rand_pos_in_spawn_area() -> Vector2:
	var pos: Vector2
	
	while marker_top_left_in.position.x <= pos.x && pos.x <= marker_bot_right_in.position.x && marker_top_left_in.position.y <= pos.y && pos.y <= marker_bot_right_in.position.y:
		pos = Vector2(randf_range(marker_top_left_out.position.x, marker_bot_right_out.position.x), randf_range(marker_top_left_out.position.y, marker_bot_right_out.position.y))
	
	return pos

func _on_spawn_timer_timeout() -> void:
	var active_enemies = listEnemies.filter(func(e): return not e.active)
	
	if active_enemies.size() <= 0:
		print(active_enemies)
		return

	var index = int(randf_range(0, active_enemies.size() - 1))
	active_enemies[index].active = true
