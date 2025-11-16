extends Node2D

@export var delivered_common_scene: PackedScene      
@export var delivered_explosive_scene: PackedScene   
@export var max_visual_boxes: int = 40               

@onready var start_marker: Marker2D = $TopLeft
@onready var end_marker: Marker2D = $BottomRight
@onready var tick_timer: Timer = $TickTimer
@onready var area_2d_2: StaticBody2D = $Area2D2      
@onready var top_left_del: Marker2D = $TopLeftDel
@onready var bottom_right_del: Marker2D = $BottomRightDel

var player_inside: bool = false
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var delivered_boxes: Array[Node2D] = []              


func _ready() -> void:
	area_2d_2.add_to_group("world")
	rng.randomize()


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
		return false

	var p: Vector2 = player.global_position

	var p1: Vector2 = start_marker.global_position
	var p2: Vector2 = end_marker.global_position

	var min_x: float = min(p1.x, p2.x)
	var max_x: float = max(p1.x, p2.x)
	var min_y: float = min(p1.y, p2.y)
	var max_y: float = max(p1.y, p2.y)

	return p.x >= min_x and p.x <= max_x and p.y >= min_y and p.y <= max_y


func _on_tick_timer_timeout() -> void:
	if GameController.gameFinished:
		return

	var selected_box: int = GameController.getSelectedBox()

	var can_score := false
	if selected_box == 0 and GameController.getQtdCommonBoxesHeld() > 0:
		can_score = true
	elif selected_box == 1 and GameController.getQtdExplosiveBoxesHeld() > 0:
		can_score = true

	if not can_score:
		return

	GameController.updateScore(selected_box)

	_spawn_delivered_box(selected_box)


func _get_random_spawn_position() -> Vector2:
	var p1: Vector2 = top_left_del.global_position
	var p2: Vector2 = bottom_right_del.global_position

	var min_x: float = min(p1.x, p2.x)
	var max_x: float = max(p1.x, p2.x)
	var min_y: float = min(p1.y, p2.y)
	var max_y: float = max(p1.y, p2.y)

	var x: float = rng.randf_range(min_x, max_x)
	var y: float = rng.randf_range(min_y, max_y)

	return Vector2(x, y)


func _spawn_delivered_box(box_type: int) -> void:
	var scene: PackedScene = null

	if box_type == 0:
		scene = delivered_common_scene
	else:
		scene = delivered_explosive_scene

	if scene == null:
		return

	var box: Node2D = scene.instantiate()
	box.global_position = _get_random_spawn_position()

	get_parent().add_child(box)
	delivered_boxes.append(box)

	if delivered_boxes.size() > max_visual_boxes:
		var old: Node2D = delivered_boxes.pop_front() as Node2D
		if is_instance_valid(old):
			old.queue_free()
