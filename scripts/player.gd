extends Node2D

var curr_pos = Vector2i(0,0)
var tile_height
var w
var h
var player_menu
@export var cursor_sprite : AnimatedSprite2D
var my_turn = true

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
	cursor_sprite.play("default", .5, false)
	
#Limit screen
func limit_pos() -> void:
	curr_pos.x = clamp(curr_pos.x,0,w)
	curr_pos.y = clamp(curr_pos.y,0,h)
	
# Movement and state changes
func _unhandled_key_input(event: InputEvent) -> void:
	if !my_turn: # No player changes during AI turn
		return
	if current_state != player_state.MENUING: # Movement
			_handle_move(event)
	#print(current_state)
	match current_state:
		player_state.MENUING: #Inputs while menuing are handled by menu
			pass
		player_state.SPAWN_NEW_CAMP:
			if event.is_action_pressed("action_a"):
				broadcast_action.emit("spawn_new_camp")
		player_state.SELECT_CAMP_FOR_ACTION:
			if event.is_action_pressed("action_a"):
				broadcast_action.emit("select_camp_for_action")
			if event.is_action_pressed("action_start"):
				pass # TODO implement active camp checker
		player_state.ACTION_SABOTAGE:
			if event.is_action_pressed("action_a"):
				broadcast_action.emit("sabotage")
			if event.is_action_pressed("action_b"):
				broadcast_action.emit("return_to_menu")
		player_state.ACTION_DIG:
			if event.is_action_pressed("action_a"):
				broadcast_action.emit("dig")
			if event.is_action_pressed("action_b"):
				broadcast_action.emit("return_to_menu")

func change_state(state : player_state) -> void:
	if !my_turn:
		cursor_sprite.set_visible(false)
		return
	cursor_sprite.set_visible(true)
	current_state = state
	if (state == player_state.MENUING):
		cursor_sprite.play("default", .2, false)
	else:
		cursor_sprite.play("default", .5, false)

func _handle_move(event: InputEvent) -> void:
	if event.is_action_pressed("action_left"):
		curr_pos.x -= 1
	if event.is_action_pressed("action_right"):
		curr_pos.x += 1
	if event.is_action_pressed("action_up"):
		curr_pos.y -= 1
	if event.is_action_pressed("action_down"):
		curr_pos.y += 1
	limit_pos()
	position = Vector2i(
		curr_pos.x * tile_height + tile_height/2, 
		curr_pos.y * tile_height + tile_height/2)

signal broadcast_action
