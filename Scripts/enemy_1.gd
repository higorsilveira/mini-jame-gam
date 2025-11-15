extends CharacterBody2D

@export var speed: float = 5000.0
@export var max_hitpoints: float = 5.0
@onready var player: Node2D = get_tree().get_nodes_in_group("player")[0]
@onready var hitbox: CollisionShape2D = $CollisionShape2D

var active: bool = false
var hitpoints: float = 0.0


func _ready() -> void:
	hitpoints = max_hitpoints
	hide()
	hitbox.set_deferred("disabled", true) 


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
	if hitpoints <= 0.0:
		die()


func die() -> void:
	active = false
	hitpoints = 0.0
	hide()
	hitbox.set_deferred("disabled", true)


func reset_enemy() -> void:
	hitpoints = max_hitpoints
	active = true
	show()
	hitbox.disabled = false
