extends CanvasLayer

@onready var label_common_boxes = $Box_Resource/Box_Comum_Count
@onready var label_explosive_boxes = $Box_Resource/Box_Explosive_Count
@onready var box_selected_comum: Sprite2D = $Box_Resource/Box_Selected_Comum
@onready var box_selected_box: Sprite2D = $Box_Resource/Box_Selected_Box
@onready var count_score: Label = $Score/CountScore
@onready var game_over_ui: Control = $GameOverUI
@onready var count_score_game_over: Label = $GameOverUI/ColorRect/CountScore

func _ready() -> void:
	game_over_ui.visible = false

func _process(delta: float) -> void:
	label_common_boxes.text = str(GameController.getQtdCommonBoxesHeld())
	label_explosive_boxes.text = str(GameController.getQtdExplosiveBoxesHeld())
	count_score.text = str(GameController.getScore())
	count_score_game_over.text = str(GameController.getScore())
	var selectedbox = GameController.getSelectedBox()
	if selectedbox == 0:
		box_selected_comum.visible = true
		box_selected_box.visible = false
	if selectedbox == 1:
		box_selected_comum.visible = false
		box_selected_box.visible = true
	if GameController.gameFinished :
		game_over_ui.visible = true


func _on_restart_pressed() -> void:
	GameController.restartGame()
	get_tree().reload_current_scene()
