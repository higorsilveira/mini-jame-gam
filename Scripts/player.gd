extends CharacterBody2D

@export var speed: float = 200.0
@export var max_hitpoints: int = 5
@export var invincibility_time: float = 0.5

@onready var anim: AnimatedSprite2D = $AnimatedSprit2D
@onready var marker_2d: Marker2D = $Marker2D

var last_direction: Vector2 = Vector2.DOWN
var hitpoints: int = 0
var can_take_damage: bool = true

func _ready() -> void:
	add_to_group("player")
	hitpoints = max_hitpoints


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Vector2.ZERO

	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	input_vector = input_vector.normalized()
	
	# Trocar tipo de caixa
	if Input.is_action_just_pressed("switch_box"):
		GameController.switchBox()
	
	# Arremessar caixa
	if Input.is_action_just_pressed("throw_box"):
		var dir: Vector2 = last_direction
		if dir == Vector2.ZERO:
			dir = Vector2.DOWN
		var mouse_pos: Vector2 = get_global_mouse_position()
		GameController.throw_selected_box(marker_2d.global_position, mouse_pos, dir)

	velocity = input_vector * speed
	move_and_slide()

	_update_animation(input_vector)


func _update_animation(input_vector: Vector2) -> void:
	if input_vector.length() > 0.0:
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0.0:
				anim.play("move_right")
				last_direction = Vector2.RIGHT
			else:
				anim.play("move_left")
				last_direction = Vector2.LEFT
		else:
			if input_vector.y > 0.0:
				anim.play("move_down")
				last_direction = Vector2.DOWN
			else:
				anim.play("move_up")
				last_direction = Vector2.UP
	else:
		match last_direction:
			Vector2.RIGHT:
				anim.play("idle_right")
			Vector2.LEFT:
				anim.play("idle_left")
			Vector2.UP:
				anim.play("idle_up")
			Vector2.DOWN:
				anim.play("idle_down")


func take_damage(amount: int) -> void:
	if not can_take_damage:
		return
	
	can_take_damage = false
	hitpoints -= amount
	print("Player levou dano:", amount, " | HP:", hitpoints)

	if hitpoints <= 0:
		die()
		return

	# Invencibilidade temporária
	_flash_damage()
	await get_tree().create_timer(invincibility_time).timeout
	can_take_damage = true


func _flash_damage() -> void:
	# Efeito simples: piscar o player
	anim.modulate = Color(1, 0.5, 0.5, 1.0)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color(1, 1, 1, 1)


func die() -> void:
	print("Player morreu!")
	GameController.gameFinished = true
	# Você pode querer travar o movimento / input visualmente
	set_physics_process(false)
	# opcional: esconder o player
	# hide()
