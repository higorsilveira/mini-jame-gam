extends Node2D

@onready var start_marker: Marker2D = $TopLeft
@onready var end_marker: Marker2D = $BottomRight
@onready var tick_timer: Timer = $TickTimer
@onready var area_2d_2: StaticBody2D = $Area2D2

var player_inside: bool = false

func _ready() -> void:
	area_2d_2.add_to_group("world")

func _process(delta: float) -> void:
	if _is_player_inside():
		if not player_inside:
			player_inside = true
			tick_timer.start()
	else:
		if player_inside:
			player_inside = false
			tick_timer.stop()


func _is_player_inside() -> bool:
	var player: Node2D = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		print("Não achou o player")
		return false

	var p: Vector2 = player.global_position

	var p1: Vector2 = start_marker.global_position
	var p2: Vector2 = end_marker.global_position

	var min_x: float = p1.x if p1.x < p2.x else p2.x
	var max_x: float = p1.x if p1.x > p2.x else p2.x
	var min_y: float = p1.y if p1.y < p2.y else p2.y
	var max_y: float = p1.y if p1.y > p2.y else p2.y

	return p.x >= min_x and p.x <= max_x and p.y >= min_y and p.y <= max_y

func _on_tick_timer_timeout() -> void:
	GameController.updateScore(GameController.getSelectedBox())
