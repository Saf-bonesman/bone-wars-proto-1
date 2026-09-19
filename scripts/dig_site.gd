extends Node2D

@onready var animation : AnimatedSprite2D = $DigAnimator
@onready var label : AnimatedSprite2D = $PlayerLabel
@onready var bones : AnimatedSprite2D = $BonesLabel
@onready var connectors : Node2D = $Connectors
var dig_turn_counter = 2
var dig_type = "low"
var owning_player = 0
var owning_camp : Vector2i
var my_location : Vector2i

func _ready() -> void:
	if owning_player == 0:
		animation.play("default")
	else:
		animation.play("dark")
	label.frame = owning_player
	show_connector()
	match dig_type:
		"high":
			bones.frame = 2
		"med":
			bones.frame = 1
		"low":
			bones.frame = 0

func continue_digsite() -> void:
	dig_turn_counter -=1
	if dig_turn_counter <= 0:
		end_digsite(false)

func end_digsite(destroy : bool) -> void:
	if destroy:
		queue_free()
		return
	match dig_type:
		"low":
			dig_dug.emit(randi_range(0,1))
		"med":
			dig_dug.emit(randi_range(1,2))
		"high":
			dig_dug.emit(randi_range(2,3))
	queue_free()

func show_connector() -> void:
	var dir : String = ""
	if owning_camp.x > my_location.x:
		dir = "East"
	elif owning_camp.y > my_location.y:
		dir = "South"
	elif owning_camp.x < my_location.x:
		dir = "West"
	else:
		dir = "North"
	if dir == "":
		return
	connectors.get_node(dir+str(owning_player)).visible = true

signal dig_dug
