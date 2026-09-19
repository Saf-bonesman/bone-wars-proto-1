extends Node2D

@onready var explosion_animation = $Explosion
var loc : Vector2i

func _ready() -> void:
	explosion_animation.play("default")

func _on_explosion_animation_finished() -> void:
	digsite_animation_complete.emit(loc)
	queue_free()

signal digsite_animation_complete
