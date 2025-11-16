extends Node2D

@export var radius: float = 80.0
@export var duration: float = 0.30
@export var visual_multiplier: float = 1.5

@onready var boom: AudioStreamPlayer2D = $BoomPlayer
@onready var timer: Timer = $Timer
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite

# textura base do primeiro frame da animação
@onready var base_texture: Texture2D = (
	explosion_sprite.sprite_frames.get_frame_texture("explosion", 0)
)

var elapsed: float = 0.0


func _ready() -> void:
	timer.wait_time = duration
	timer.timeout.connect(_on_Timer_timeout)

	hide()
	set_process(false)

	explosion_sprite.stop()
	explosion_sprite.frame = 0


func play(position: Vector2, new_radius: float) -> void:
	radius = new_radius
	global_position = position
	elapsed = 0.0
	show()
	set_process(true)
	timer.start()

	if boom:
		boom.play()

	if base_texture:
		var tex_size: Vector2 = base_texture.get_size()
		var base_radius: float = tex_size.x / 2.0 
		var target_radius: float = radius * visual_multiplier
		var scale_factor: float = target_radius / base_radius
		explosion_sprite.scale = Vector2.ONE * scale_factor / 2


	explosion_sprite.animation = "explosion"
	explosion_sprite.frame = 0
	explosion_sprite.play()

	var frame_count: int = 0
	var frames: SpriteFrames = explosion_sprite.sprite_frames
	if frames:
		frame_count = frames.get_frame_count(explosion_sprite.animation)

	if duration > 0.0 and frame_count > 0:
		explosion_sprite.speed_scale = float(frame_count) / duration


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
