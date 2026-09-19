extends Node2D

var curr_pos = Vector2i(0,0)
var move_timer
var tile_height
var w
var h
var player_menu
@export var cursor_sprite : AnimatedSprite2D

enum player_state {
	ENCAMP,
	CAMP_SELECTION,
	MENUING,
	ACTION_SABOTAGE,
	ACTION_DIG
}

var current_state = player_state.ENCAMP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_timer = get_node("MoveTimer")
	move_timer.start()
	cursor_sprite.play("default", .5, false)
	
#Limit screen
func limit_pos() -> void:
	curr_pos.x = clamp(curr_pos.x,0,w)
	curr_pos.y = clamp(curr_pos.y,0,h)
	
# Movin' the cursor
func _input(_event) -> void:
	match current_state:
		player_state.ENCAMP:
			if Input.is_action_pressed("action_a"):
				print("encamp")
				broadcast_action.emit("encamp")
				current_state = player_state.CAMP_SELECTION
		player_state.CAMP_SELECTION:
			if Input.is_action_pressed("action_a"):
				print("choose camp")
				current_state = player_state.MENUING
		player_state.MENUING:
			#move_timer.set_paused(true)
			if Input.is_action_pressed("action_a"):
				print("choose menu option")
				broadcast_action.emit("menu", curr_pos)
				current_state = player_state.ACTION_SABOTAGE
		player_state.ACTION_SABOTAGE:
			#move_timer.set_paused(false)
			if Input.is_action_pressed("action_a"):
				print("big esplostion")
				broadcast_action.emit("destroy")
				current_state = player_state.ACTION_DIG
		player_state.ACTION_DIG:
			if Input.is_action_pressed("action_a"):
				broadcast_action.emit("dig")
				print("diggy diggy hole")
				current_state = player_state.ENCAMP
				broadcast_action.emit("choose_camp_loc")
				
# repeat timer
func _on_move_timer_timeout() -> void:
	match current_state:
		player_state.MENUING:
			pass
		_:
			_handle_move()

func _handle_move() -> void:
	if Input.is_action_pressed("action_left"):
		curr_pos.x -= 1
		# print("moved l " + str(curr_pos.x) + ", " + str(curr_pos.y))
	if Input.is_action_pressed("action_right"):
		curr_pos.x += 1
		# print("moved r " + str(curr_pos.x) + ", " + str(curr_pos.y))
	if Input.is_action_pressed("action_up"):
		curr_pos.y -= 1
		# print("moved up " + str(curr_pos.x) + ", " + str(curr_pos.y))
	if Input.is_action_pressed("action_down"):
		curr_pos.y += 1
		# print("moved down " + str(curr_pos.x) + ", " + str(curr_pos.y))
	limit_pos()
	position = Vector2i(
		curr_pos.x * tile_height + tile_height/2, 
		curr_pos.y * tile_height + tile_height/2)

signal broadcast_action
