extends CharacterBody2D

@export var speed: float = 5000.0
@export var max_hitpoints: float = 5.0
@export var damage_to_player: int = 1

@onready var player: Node2D = get_tree().get_nodes_in_group("player")[0]
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var damage_area: Area2D = $DamageArea
@onready var damage_shape: CollisionShape2D = $DamageArea/CollisionShape2D
@onready var sprite: CanvasItem = $Sprite2D

var active: bool = false
var hitpoints: float = 0.0


func _ready() -> void:
	hitpoints = max_hitpoints
	hide()
	hitbox.set_deferred("disabled", true)
	damage_shape.set_deferred("disabled", true)

	damage_area.body_entered.connect(_on_damage_area_body_entered)


func _physics_process(delta: float) -> void:
	if not active:
		return

	var direction: Vector2 = position.direction_to(player.position)
	velocity = direction * speed * delta
	move_and_slide()


func take_hit(damage: int) -> void:
	if not active:
		return

	print("enemy take hit")
	hitpoints -= damage

	GameController.show_damage_number(damage, global_position, false)

	_flash_damage()

	if hitpoints <= 0.0:
		die()


func die() -> void:
	active = false
	hitpoints = 0.0
	hide()
	hitbox.set_deferred("disabled", true)
	damage_shape.set_deferred("disabled", true)


func reset_enemy() -> void:
	hitpoints = max_hitpoints
	active = true
	show()
	hitbox.disabled = false
	damage_shape.disabled = false


func _on_damage_area_body_entered(body: Node) -> void:
	if not active:
		return

	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage_to_player, global_position)


func _flash_damage() -> void:
	sprite.modulate = Color(1, 0.5, 0.5, 1.0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)
