extends CanvasLayer

@onready var label_common_boxes = $Box_Resource/Box_Comum_Count
@onready var label_explosive_boxes = $Box_Resource/Box_Explosive_Count

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	label_common_boxes.text = str(GameController.getQtdCommonBoxesHeld())
	label_explosive_boxes.text = str(GameController.getQtdExplosiveBoxesHeld())
