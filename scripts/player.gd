extends Node2D

var curr_pos = [position[0],position[1]]
var move_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_timer = get_node("MoveTimer")

#Limit screen
func limit_pos() -> void:
	curr_pos[0] = clamp(curr_pos[0],24,136)
	curr_pos[1] = clamp(curr_pos[1],8,88)
	
# Movin' the cursor
func _input(_event) -> void:
	move_timer.start()
	if Input.is_action_pressed("action_left"):
		curr_pos[0] -= 16
		limit_pos()
		position = Vector2(curr_pos[0],curr_pos[1])
	if Input.is_action_pressed("action_right"):
		curr_pos[0] += 16
		limit_pos()
		position = Vector2(curr_pos[0],curr_pos[1])
	if Input.is_action_pressed("action_up"):
		curr_pos[1] -= 16
		limit_pos()
		position = Vector2(curr_pos[0],curr_pos[1])
	if Input.is_action_pressed("action_down"):
		curr_pos[1] += 16
		limit_pos()
		position = Vector2(curr_pos[0],curr_pos[1])
	# stop timer when not in use
	if Input.is_action_just_released("action_left") || \
	Input.is_action_just_released("action_right") || \
	Input.is_action_just_released("action_up") || \
	Input.is_action_just_released("action_down"):
		move_timer.stop()
		
# repeat timer
func _on_move_timer_timeout() -> void:
	move_timer.start()
