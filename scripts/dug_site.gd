extends Node2D

@onready var explosion_animation = $Explosion
@onready var explosion_sound = $ExplodoPlayer
var loc : Vector2i

func _ready() -> void:
	explosion_animation.play("default")
	explosion_sound.play(0.0)

func _on_explosion_animation_finished() -> void:
	digsite_animation_complete.emit(loc)
	queue_free()

signal digsite_animation_complete
