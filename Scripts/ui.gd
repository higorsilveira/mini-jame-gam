extends CanvasLayer

@onready var label_common_boxes = $Box_Resource/Box_Comum_Count
@onready var label_explosive_boxes = $Box_Resource/Box_Explosive_Count
@onready var box_selected_comum: Sprite2D = $Box_Resource/Box_Selected_Comum
@onready var box_selected_box: Sprite2D = $Box_Resource/Box_Selected_Box
@onready var count_score: Label = $Score/CountScore

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	label_common_boxes.text = str(GameController.getQtdCommonBoxesHeld())
	label_explosive_boxes.text = str(GameController.getQtdExplosiveBoxesHeld())
	count_score.text = str(GameController.getScore())
	var selectedbox = GameController.getSelectedBox()
	if selectedbox == 0:
		box_selected_comum.visible = true
		box_selected_box.visible = false
	if selectedbox == 1:
		box_selected_comum.visible = false
		box_selected_box.visible = true
