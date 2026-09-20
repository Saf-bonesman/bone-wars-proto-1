extends Node2D

var curr_pos = Vector2i(0,0)
var move_timer
var tile_height
var w
var h
var player_menu
@export var cursor_sprite : AnimatedSprite2D

enum player_state {
	SPAWN_NEW_CAMP,
	SELECT_CAMP_FOR_ACTION,
	MENUING,
	ACTION_SABOTAGE,
	ACTION_DIG
}

var current_state = player_state.SPAWN_NEW_CAMP

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
	#print(current_state)
	match current_state:
		player_state.SPAWN_NEW_CAMP:
			if Input.is_action_pressed("action_a"):
				broadcast_action.emit("spawn_new_camp")
		player_state.SELECT_CAMP_FOR_ACTION:
			move_timer.set_paused(false)
			cursor_sprite.play("default", .5, false)
			if Input.is_action_pressed("action_a"):
				broadcast_action.emit("select_camp_for_action")
		player_state.MENUING:
			move_timer.set_paused(true)
			cursor_sprite.play("default", .2, false)
			# inputs while menuing are handled by menu
			#if Input.is_action_pressed("action_b"):
				#broadcast_action.emit("exit_menu")
		player_state.ACTION_SABOTAGE:
			if Input.is_action_pressed("action_a"):
				broadcast_action.emit("sabotage")
			if Input.is_action_pressed("action_b"):
				broadcast_action.emit("return_to_menu")
		player_state.ACTION_DIG:
			if Input.is_action_pressed("action_a"):
				broadcast_action.emit("dig")
			if Input.is_action_pressed("action_b"):
				broadcast_action.emit("return_to_menu")

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
	if Input.is_action_pressed("action_right"):
		curr_pos.x += 1
	if Input.is_action_pressed("action_up"):
		curr_pos.y -= 1
	if Input.is_action_pressed("action_down"):
		curr_pos.y += 1
	limit_pos()
	position = Vector2i(
		curr_pos.x * tile_height + tile_height/2, 
		curr_pos.y * tile_height + tile_height/2)

#func set_state(text_act : String) -> void:
	#match text_act:
		#"Sabotage":
			#current_state = player_state.ACTION_SABOTAGE
		#"Dig":
			#current_state = player_state.ACTION_DIG
		#"Pass":
			##disable camp?
			#broadcast_action.emit("exit_menu")
			#current_state = player_state.SELECT_CAMP_FOR_ACTION
		#"Back":
			#broadcast_action.emit("exit_menu")
			#current_state = player_state.SELECT_CAMP_FOR_ACTION

signal broadcast_action
