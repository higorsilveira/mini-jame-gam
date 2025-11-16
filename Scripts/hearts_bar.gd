extends Control

@export var max_hearts: int = 15
@export var heart_size: float = 20.0
@export var spacing: float = 6.0

var current_hearts: int = 5


func _process(delta: float) -> void:
	current_hearts = GameController.getPlayerLife()
	queue_redraw()


func _draw() -> void:
	for i in max_hearts:
		var x = i * (heart_size + spacing)
		var pos = Vector2(x + heart_size/2, heart_size/2)

		var is_filled = i < current_hearts
		_draw_heart(pos, heart_size, is_filled)

func _draw_heart(center: Vector2, size: float, filled: bool) -> void:
	var r = size * 0.25
	var bottom = center + Vector2(0, size * 0.3)

	var fill_color = Color(1, 0, 0) if filled else Color(0.3, 0, 0)
	var border_color = Color(0, 0, 0)

	var left_circle = center + Vector2(-r, -r * 0.5)
	var right_circle = center + Vector2(r, -r * 0.5)

	draw_circle(left_circle, r, fill_color)
	draw_circle(right_circle, r, fill_color)

	var p1 = center + Vector2(-r * 2, -r * 0.1)
	var p2 = center + Vector2(r * 2, -r * 0.1)
	var p3 = bottom

	draw_polygon([p1, p2, p3], [fill_color])

	draw_circle(left_circle, r, border_color, false, 2)
	draw_circle(right_circle, r, border_color, false, 2)
	draw_polyline([p1, p2, p3, p1], border_color, 2)
