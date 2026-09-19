extends Node2D

@onready var animation : AnimatedSprite2D = $DigAnimator
var dig_turn_counter = 2
var dig_type = "low"
var owning_player

func _ready() -> void:
	animation.play("default")

func continue_digsite() -> void:
	dig_turn_counter -=1

func end_digsite() -> void:
	match dig_type:
		"low":
			dig_dug.emit(randi_range(0,1))
		"med":
			dig_dug.emit(randi_range(1,2))
		"high":
			dig_dug.emit(randi_range(2,3))
	queue_free()

signal dig_dug
