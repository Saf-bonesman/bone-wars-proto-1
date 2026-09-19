extends Node2D

@onready var animation : AnimatedSprite2D = $DigAnimator
@onready var label : Label = $bg/player_label
var dig_turn_counter = 2
var dig_type = "low"
var owning_player = 0
var my_location

func _ready() -> void:
	animation.play("default")
	label.text = str(owning_player+1)

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

signal dig_dug
