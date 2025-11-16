extends Area2D
class_name BoxExplosiveProjectile

@export var speed: float = 500.0
@export var explosion_radius: float = 80.0
@export var damage: int = 2
@export var explosion_scene: PackedScene

var direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()


func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return
	global_position += direction * speed * delta


func _explode() -> void:
	if explosion_scene != null:
		var explosion_instance := explosion_scene.instantiate()
		get_tree().current_scene.add_child(explosion_instance)

		if explosion_instance.has_method("play"):
			explosion_instance.play(global_position, explosion_radius)
		else:
			explosion_instance.global_position = global_position

	var space_state := get_world_2d().direct_space_state

	var shape := CircleShape2D.new()
	shape.radius = explosion_radius

	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, global_position)
	params.collide_with_bodies = true

	var results := space_state.intersect_shape(params, 32)

	for result in results:
		var body: Node = result.get("collider")
		if body != null and body.is_in_group("enemy") and body.has_method("take_hit"):
			body.take_hit(damage)

	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		_explode()
		return

	if body.is_in_group("world") or body.is_in_group("wall") or body.name == "Limits":
		_explode()


func _on_VisibleOnScreenNotifier2D_screen_exited() -> void:
	pass
