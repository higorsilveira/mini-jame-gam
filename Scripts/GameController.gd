extends Node

const GAME_MUSIC: AudioStream = preload("res://Audio/Mini-Jame-Gam-Music.wav")

var music_player: AudioStreamPlayer

var qtdCommonBoxesHeld: int = 99999
var qtdExplosiveBoxesHeld: int = 99999
var score: int = 0
var selected_box: int = 0  # 0 = comum, 1 = explosiva
var gameFinished := false
var playerLife := 15

const COMMON_BOX_PROJECTILE_SCENE: PackedScene = preload("res://Scenes/BoxCommonProjectile.tscn")
const EXPLOSIVE_BOX_PROJECTILE_SCENE: PackedScene = preload("res://Scenes/BoxExplosiveProjectile.tscn")
const DAMAGE_NUMBER_SCENE: PackedScene = preload("res://Scenes/DamageNumber.tscn")


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.stream = GAME_MUSIC
	add_child(music_player)

	music_player.play()
	
func restartGame() -> void:
	qtdCommonBoxesHeld = 0
	qtdExplosiveBoxesHeld = 0
	score = 0
	selected_box = 0
	gameFinished = false
	playerLife = 15

	if music_player:
		music_player.stop()
		music_player.play()
	
func getPlayerLife() -> int:
	return playerLife
	
func setPlayerLife(amount: int) -> void:
	playerLife = amount
	
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
	if gameFinished:
		return selected_box
	selected_box += 1
	if selected_box > 1:
		selected_box = 0
	return selected_box

func getSelectedBox() -> int:
	return selected_box


func updateScore(box_type: int) -> void:
	if gameFinished:
		return 
	if box_type == 0 and qtdCommonBoxesHeld > 0:
		score += 10
		subCommonBoxes()
	elif box_type == 1 and qtdExplosiveBoxesHeld > 0:
		score += 20
		subExplosivesBoxes()

func getScore() -> int:
	return score

func throw_selected_box(from_position: Vector2, to_position: Vector2, direction1: Vector2) -> void:
	if gameFinished:
		return
		
	var directionMouse = from_position.direction_to(to_position)
	if directionMouse == Vector2.ZERO:
		return
	
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

	if selected_box == 0:
		subCommonBoxes()
	else:
		subExplosivesBoxes()

	var root: Node = get_tree().current_scene
	var boxes_proj_node: Node = root.get_node_or_null("Boxes_projectile")
	if boxes_proj_node:
		boxes_proj_node.add_child(proj)
	else:
		root.add_child(proj)
		
func show_damage_number(amount: int, position: Vector2, is_player: bool = false) -> void:
	if DAMAGE_NUMBER_SCENE == null:
		return

	var n := DAMAGE_NUMBER_SCENE.instantiate() as Node2D
	n.global_position = position

	get_tree().current_scene.add_child(n)

	if n.has_method("setup"):
		n.call("setup", str(amount), is_player)
