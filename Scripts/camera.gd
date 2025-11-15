extends Camera2D

@export var target: Node2D
@export var follow_smoothness: float = 5.0

@export var dead_zone_radius: float = 144.0

@export var max_mouse_offset: float = 350.0
@export var mouse_influence: float = 1.0

@export var zoom_speed: float = 2.0
@export var min_zoom: float = 0.8
@export var max_zoom: float = 1.2


func _process(delta):
	if not target:
		return

	var target_position = target.global_position

	# Offset da camera
	var viewport := get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var center = viewport.get_visible_rect().size / 2.0
	var mouse_vector = mouse_pos - center
	var distance = mouse_vector.length()
	var mouse_offset = Vector2.ZERO

	# Zona morta
	if distance > dead_zone_radius:
		var dir = mouse_vector.normalized()
		var normalized_distance = clamp((distance - dead_zone_radius) / (max_mouse_offset), 0.0, 1.0)
		mouse_offset = dir * normalized_distance * max_mouse_offset * mouse_influence

	var desired_position = target_position + mouse_offset
	global_position = global_position.lerp(desired_position, follow_smoothness * delta)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom += Vector2(zoom_speed * 0.01, zoom_speed * 0.01)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom -= Vector2(zoom_speed * 0.01, zoom_speed * 0.01)

		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
