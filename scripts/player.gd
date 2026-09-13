extends Node2D

var curr_pos = Vector2i(0,0)
var move_timer
var tile_height
var w
var h
var player_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_timer = get_node("MoveTimer")
	move_timer.start()
	
#Limit screen
func limit_pos() -> void:
	curr_pos.x = clamp(curr_pos.x,0,w)
	curr_pos.y = clamp(curr_pos.y,0,h)
	
# Movin' the cursor
func _input(event : InputEvent) -> void:
	move_timer.start()
	if event.is_action_pressed("action_a"):
		move_timer.stop()
		player_menu = $PlayerMenu
	
# repeat timer
func _on_move_timer_timeout() -> void:
	if Input.is_action_pressed("action_left"):
		curr_pos.x -= 1
		# print("moved l " + str(curr_pos.x) + ", " + str(curr_pos.y))
	elif Input.is_action_pressed("action_right"):
		curr_pos.x += 1
		# print("moved r " + str(curr_pos.x) + ", " + str(curr_pos.y))
	elif Input.is_action_pressed("action_up"):
		curr_pos.y -= 1
		# print("moved up " + str(curr_pos.x) + ", " + str(curr_pos.y))
	elif Input.is_action_pressed("action_down"):
		curr_pos.y += 1
		# print("moved down " + str(curr_pos.x) + ", " + str(curr_pos.y))
	limit_pos()
	position = Vector2i(
		curr_pos.x * tile_height + tile_height/2, 
		curr_pos.y * tile_height + tile_height/2)
	if Input.is_action_just_released("action_move"):
		move_timer.stop()
