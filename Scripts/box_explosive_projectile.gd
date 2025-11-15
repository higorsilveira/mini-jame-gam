extends Area2D
class_name BoxExplosiveProjectile

@export var speed: float = 500.0
@export var explosion_radius: float = 64.0

var direction: Vector2 = Vector2.ZERO

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	global_position += direction * speed * delta


func _explode() -> void:
	queue_free()


func _on_Body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_hit"):
			body.call("take_hit", 2) # mais dano
		_explode()
		return


	if body.is_in_group("world") or body.is_in_group("wall") or body.name == "Limits":
		_explode()


func _on_VisibleOnScreenNotifier2D_screen_exited() -> void:
	pass
	#queue_free()
