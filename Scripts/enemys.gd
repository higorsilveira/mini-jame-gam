extends Node2D

@export var enemy_1: PackedScene
@onready var marker_top_left_out: Marker2D = $MarkerTopLeftOut
@onready var marker_top_left_in: Marker2D = $MarkerTopLeftIn
@onready var marker_bot_right_in: Marker2D = $MarkerBotRightIn
@onready var marker_bot_right_out: Marker2D = $MarkerBotRightOut

const qtdEnemies: int = 100
var listEnemies: Array = []


func _ready() -> void:
	if enemy_1 == null:
		return

	for i in qtdEnemies:
		var new_enemy = enemy_1.instantiate()
		listEnemies.append(new_enemy)
		add_child(new_enemy)
		new_enemy.position = rand_pos_in_spawn_area()
		new_enemy.active = false
		new_enemy.hide()


func rand_pos_in_spawn_area() -> Vector2:
	var pos: Vector2

	while true:
		pos = Vector2(
			randf_range(marker_top_left_out.position.x, marker_bot_right_out.position.x),
			randf_range(marker_top_left_out.position.y, marker_bot_right_out.position.y)
		)

		var inside_inner := (
			marker_top_left_in.position.x <= pos.x
			and pos.x <= marker_bot_right_in.position.x
			and marker_top_left_in.position.y <= pos.y
			and pos.y <= marker_bot_right_in.position.y
		)

		if not inside_inner:
			break

	return pos


func _on_spawn_timer_timeout() -> void:
	var inactive_enemies = listEnemies.filter(func(e): return not e.active)

	if inactive_enemies.size() <= 0:
		return

	var index: int = int(randf_range(0, inactive_enemies.size() - 1))
	var enemy = inactive_enemies[index]

	enemy.position = rand_pos_in_spawn_area()
	enemy.reset_enemy()
