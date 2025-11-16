extends CharacterBody2D

@export var speed: float = 5000.0
@export var max_hitpoints: float = 5.0
@export var damage_to_player: int = 1

@onready var player: Node2D = get_tree().get_nodes_in_group("player")[0]
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var damage_area: Area2D = $DamageArea
@onready var damage_shape: CollisionShape2D = $DamageArea/CollisionShape2D
@onready var sprite: CanvasItem = $Sprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var active: bool = false
var hitpoints: float = 0.0

var enemyTypes : Dictionary = {
	1: {
		"speed": 5000.0,
		"max_hitpoints": 5.0,
		"damage_to_player": 3,
		"scale": Vector2(1, 1)
	},
	2: {
		"speed": 2500.0,
		"max_hitpoints": 10.0,
		"damage_to_player": 5,
		"scale": Vector2(1.5, 1.5)
	},
	3: {
		"speed": 10000.0,
		"max_hitpoints": 2.0,
		"damage_to_player": 1,
		"scale": Vector2(0.75, 0.75)
	}
}


func _ready() -> void:
	_setup()
	hitpoints = max_hitpoints
	hide()
	hitbox.set_deferred("disabled", true)
	damage_shape.set_deferred("disabled", true)

	damage_area.body_entered.connect(_on_damage_area_body_entered)


func _setup() -> void:
	var tipo: int = randi_range(1, 3)
	var data: Dictionary = enemyTypes.get(tipo, {})

	speed = data.get("speed", 5000.0)
	max_hitpoints = data.get("max_hitpoints", 5.0)
	damage_to_player = data.get("damage_to_player", 1)
	scale = data.get("scale", Vector2.ONE)

	var h: float = 1.0      
	var s: float = _speed_to_s(speed) 
	var v: float = 1.0

	var cor: Color = Color.from_hsv(h, s, v)
	modulate = cor
	

func _speed_to_s(speed: float) -> float:
	var v_0_100: float

	if speed <= 5000.0:
		var t : float = clamp((speed - 2500.0) / (5000.0 - 2500.0), 0.0, 1.0)
		v_0_100 = lerp(50.0, 0.0, t)
	else:
		var t : float = clamp((speed - 5000.0) / (10000.0 - 5000.0), 0.0, 1.0)
		v_0_100 = lerp(0.0, 100.0, t)

	return v_0_100 / 100.0


func _physics_process(delta: float) -> void:
	if not active:
		return

	var direction: Vector2 = position.direction_to(player.position)
	velocity = direction * speed * delta
	move_and_slide()

	queue_redraw()


func take_hit(damage: int) -> void:
	if not active:
		return

	hitpoints -= damage

	GameController.show_damage_number(damage, global_position, false)

	_flash_damage()

	queue_redraw()

	if hitpoints <= 0.0:
		die()


func die() -> void:
	active = false
	hitpoints = 0.0
	hide()
	hitbox.set_deferred("disabled", true)
	damage_shape.set_deferred("disabled", true)
	queue_redraw()


func reset_enemy() -> void:
	hitpoints = max_hitpoints
	active = true
	show()
	hitbox.disabled = false
	damage_shape.disabled = false
	queue_redraw()


func _on_damage_area_body_entered(body: Node) -> void:
	if not active:
		return

	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage_to_player, global_position)


func _flash_damage() -> void:
	sprite.modulate = Color(1, 0.5, 0.5, 1.0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)


func _draw() -> void:
	if not active:
		return

	if max_hitpoints <= 0.0:
		return

	var ratio: float = clamp(hitpoints / max_hitpoints, 0.0, 1.0)

	var bar_width: float = 30.0 * scale.x
	var bar_height: float = 4.0

	var y_offset: float = -sprite_2d.texture.get_height() * sprite_2d.scale.y * 0.5 - 8.0
	var bar_pos: Vector2 = Vector2(-bar_width / 2.0, y_offset)

	draw_rect(
		Rect2(bar_pos, Vector2(bar_width, bar_height)),
		Color(0, 0, 0, 0.6),
		true
	)

	draw_rect(
		Rect2(bar_pos, Vector2(bar_width * ratio, bar_height)),
		Color(1, 0, 0, 0.9),
		true
	)
