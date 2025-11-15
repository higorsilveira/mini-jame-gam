extends CharacterBody2D

@export var speed: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_vector := Vector2(2, 0)
	velocity = input_vector * speed
	move_and_slide()
