extends Control

@onready var label_common_boxes = $CommonBoxesLabel
@onready var label_explosive_boxes = $ExplosiveBoxesLabel

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	label_common_boxes.text = str(GameController.getQtdCommonBoxesHeld())
	label_explosive_boxes.text = str(GameController.getQtdExplosiveBoxesHeld())
