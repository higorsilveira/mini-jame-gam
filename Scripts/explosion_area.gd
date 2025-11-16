extends Node2D

@export var radius: float = 80.0
@export var duration: float = 0.30
@export var visual_multiplier: float = 1.5

@onready var timer: Timer = $Timer

var elapsed: float = 0.0


func _ready() -> void:
	timer.wait_time = duration
	timer.timeout.connect(_on_Timer_timeout)
	hide()
	set_process(false)


func play(position: Vector2, new_radius: float) -> void:
	radius = new_radius
	global_position = position
	elapsed = 0.0
	show()
	set_process(true)
	timer.start()


func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()


func _on_Timer_timeout() -> void:
	queue_free()


func _draw() -> void:
	if duration <= 0.0:
		return

	var t: float = clamp(elapsed / duration, 0.0, 1.0)

	var max_visual_radius: float = radius * visual_multiplier

	var outer_radius: float = lerp(radius * 0.4, max_visual_radius, t)
	var inner_radius: float = lerp(radius * 0.2, radius * 0.8, t)

	var alpha: float = 1.0 - t

	draw_circle(Vector2.ZERO, outer_radius, Color(1, 0.4, 0, 0.25 * alpha))
	draw_circle(Vector2.ZERO, inner_radius, Color(1, 0.9, 0.3, 0.8 * alpha))
