extends Node2D

@export var float_distance: float = 48.0
@export var duration: float = 1.0

@onready var label: Label = $Label

var elapsed: float = 0.0
var start_pos: Vector2


func setup(text: String, is_player: bool = false) -> void:
	label.text = text
	if is_player:
		modulate = Color(1.0, 0.3, 0.3, 1.0)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)


func _ready() -> void:
	start_pos = global_position


func _process(delta: float) -> void:
	elapsed += delta
	var t : float = clamp(elapsed / duration, 0.0, 1.0)

	global_position = start_pos + Vector2(0, -float_distance * t)
	modulate.a = 1.0 - t

	if t >= 1.0:
		queue_free()
