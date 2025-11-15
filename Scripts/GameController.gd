extends Node

var qtdCommonBoxesHeld: int = 0
var qtdExplosiveBoxesHeld: int = 0
var score: int = 0
var selected_box: int = 1  # 0 = comum, 1 = explosiva

# Carrega as cenas dos projéteis em tempo de compilação
const COMMON_BOX_PROJECTILE_SCENE: PackedScene = preload("res://Scenes/BoxCommonProjectile.tscn")
const EXPLOSIVE_BOX_PROJECTILE_SCENE: PackedScene = preload("res://Scenes/BoxExplosiveProjectile.tscn")


func getQtdCommonBoxesHeld() -> int:
	return qtdCommonBoxesHeld

func addCommonBoxes(amount: int) -> void:
	qtdCommonBoxesHeld += amount

func getQtdExplosiveBoxesHeld() -> int:
	return qtdExplosiveBoxesHeld

func addExplosiveBoxes(amount: int) -> void:
	qtdExplosiveBoxesHeld += amount

func subExplosivesBoxes() -> void:
	qtdExplosiveBoxesHeld = max(qtdExplosiveBoxesHeld - 1, 0)

func subCommonBoxes() -> void:
	qtdCommonBoxesHeld = max(qtdCommonBoxesHeld - 1, 0)


func switchBox() -> int:
	selected_box += 1
	if selected_box > 1:
		selected_box = 0
	return selected_box

func getSelectedBox() -> int:
	return selected_box


func updateScore(box_type: int) -> void:
	if box_type == 0 and qtdCommonBoxesHeld > 0:
		score += 10
		subCommonBoxes()
	elif box_type == 1 and qtdExplosiveBoxesHeld > 0:
		score += 20
		subExplosivesBoxes()

func getScore() -> int:
	return score

func throw_selected_box(from_position: Vector2, to_position: Vector2, direction1: Vector2) -> void:
	var directionMouse = from_position.direction_to(to_position)
	print("Chegou aqui")
	if directionMouse == Vector2.ZERO:
		return
	
	print("Chegou aqui")
	# Garante que tem munição
	if selected_box == 0 and qtdCommonBoxesHeld <= 0:
		return
	if selected_box == 1 and qtdExplosiveBoxesHeld <= 0:
		return

	var scene_to_use: PackedScene = null

	match selected_box:
		0:
			scene_to_use = COMMON_BOX_PROJECTILE_SCENE
		1:
			scene_to_use = EXPLOSIVE_BOX_PROJECTILE_SCENE
		_:
			scene_to_use = COMMON_BOX_PROJECTILE_SCENE

	if scene_to_use == null:
		return

	var proj: Node2D = scene_to_use.instantiate() as Node2D
	proj.global_position = from_position
	if proj.has_method("set_direction"):
		proj.call("set_direction", directionMouse.normalized())

	# Desconta a caixa usada como munição
	if selected_box == 0:
		subCommonBoxes()
	else:
		subExplosivesBoxes()

	# Se tiver um nó "Boxes_projectile" na cena:
	var root: Node = get_tree().current_scene
	var boxes_proj_node: Node = root.get_node_or_null("Boxes_projectile")
	if boxes_proj_node:
		boxes_proj_node.add_child(proj)
	else:
		root.add_child(proj)
