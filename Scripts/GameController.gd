extends Node

var qtdCommonBoxesHeld = 0
var qtdExplosiveBoxesHeld = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func getQtdCommonBoxesHeld() -> int:
	return qtdCommonBoxesHeld
	
func addCommonBoxes(amount: int) -> void:
	qtdCommonBoxesHeld += amount
	
func getQtdExplosiveBoxesHeld() -> int:
	return qtdExplosiveBoxesHeld
	
func addExplosiveBoxes(amount: int) -> void:
	qtdExplosiveBoxesHeld += amount
