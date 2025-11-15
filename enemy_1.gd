extends CharacterBody2D

#@export var player: PackedScene
@export var speed: float = 5000.0
@export var max_hitpoints: float = 1000.0
@onready var player = get_tree().get_nodes_in_group("player")[0]

var active: bool = false
var hitpoints = max_hitpoints
	
func _physics_process(delta: float) -> void:
	if not active:
		return

	var direction = position.direction_to(player.position)
	velocity = direction * speed * delta
	move_and_slide()
	
func take_hit(damage: int) -> void:
	print("enemy take hit")
	hitpoints -= damage
	if hitpoints <= 0:
		die()
	
func die() -> void:
	active = false
