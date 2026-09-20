extends Node2D

@onready var HUD : Control = $HUD
@onready var Map : Node2D = $Map
var score_array : Array[int] = [0, 0, 0, 0, 0]
var current_player_turn : int = 0
@export var player_count : int = 1
var last_selected_camp : Vector2i = Vector2i(0,0)
var available_actions : Dictionary
var usable_camps : Array[Vector2i]
## test
func _unhandled_input(_event: InputEvent) -> void:
	pass
	#if Input.is_action_just_pressed("debug_middlemoues"):
		#_restart_game()
	#if Input.is_action_just_pressed("debug_rightmouse"):
		#end_turn()
	#if Input.is_action_just_pressed("debug_key_1"):
		#Map.display_range(1, Map.Player.curr_pos)
	#if Input.is_action_just_pressed("debug_key_2"):
		#Map.display_range(2, Map.Player.curr_pos)
	#if Input.is_action_just_pressed("debug_key_3"):
		#Map.display_range(3, Map.Player.curr_pos)
	#if Input.is_action_just_pressed("debug_key_4"):
		#Map.undraw_range()
	##if Input.is_action_just_pressed("action_left"):
	##	_sabotage_punishment()
	##if Input.is_action_just_pressed("action_up"):
	##	_score_new_building()

func _ready() -> void:
	_restart_game()
	Map.Player.broadcast_action.connect(_on_broadcast_action)

func _restart_game() -> void:
	#i made this size 4 in case we ever want 4 players but that aint happening this jam
	score_array = [0, 0, 0, 0, 0] 
	current_player_turn = 0
	Map.board_init()
	Map.display_encamp_range()
	HUD.init_player_displays()
	_reset_usable_camps()

func _on_broadcast_action(action_type : String) -> void:
	match action_type:
		"spawn_new_camp":
			_spawn_camp(Map.Player.curr_pos)
		"select_camp_for_action":
			_set_last_selected_camp()
			_select_camp_for_action_and_open_menu()
		"return_to_menu":
			_select_camp_for_action_and_open_menu()
		"exit_menu":
			_exit_menu()
		"dig":
			_spawn_digsite()
		"sabotage":
			_do_sabotage()
		"menu":
			_load_menu()

func _check_for_camp_spots() -> void:
	Map.undraw_range()
	var available_camp_spots = Map.available_camp_spots()
	if available_camp_spots.is_empty():
		_no_available_spots_to_camp()
		return
	Map.display_encamp_range()
	Map.Player.current_state = Map.Player.player_state.SPAWN_NEW_CAMP

func _spawn_camp(selected_location : Vector2i) -> void:
	var available_camp_spots = Map.available_camp_spots()
	if available_camp_spots.has(selected_location):
		Map.undraw_range()
		Map.spawn_camp()
		Map.Player.current_state = Map.Player.player_state.SELECT_CAMP_FOR_ACTION

func _no_available_spots_to_camp() -> void:
	Map.Player.current_state = Map.Player.player_state.SELECT_CAMP_FOR_ACTION

func _set_last_selected_camp() -> void:
	## TODO only run this if the spot is a camp
	last_selected_camp = Map.Player.curr_pos
	available_actions = Map.available_actions(last_selected_camp)

func _clear_available_actions() -> void:
	available_actions.clear()

func _select_camp_for_action_and_open_menu() -> void:
	if !usable_camps.has(last_selected_camp):
		return
	var actions_for_menu : Array[String]
	if !available_actions.get("Sabotage").is_empty():
		actions_for_menu.append("Sabotage")
	if !available_actions.get("Dig").is_empty():
		actions_for_menu.append("Dig")
	actions_for_menu.append("Back")
	actions_for_menu.append("Pass")
	print(actions_for_menu)
	## TODO Make this load the menu with the options above ^^^
	_load_menu()	
	Map.Player.current_state = Map.Player.player_state.MENUING
	# open menu here with the options in this array

func _spawn_digsite() -> void:
	var selected_space = Map.Player.curr_pos
	if (available_actions.get("Dig").has(selected_space)):
		Map.spawn_digsite()
		_clear_available_actions()
		usable_camps.erase(last_selected_camp)
		_return_to_camp_selection()

func _do_sabotage() -> void:
	var selected_space = Map.Player.curr_pos
	if (available_actions.get("Sabotage").has(selected_space)):
		Map.destroy_digsite()
		_clear_available_actions()
		usable_camps.erase(last_selected_camp)
		_return_to_camp_selection()

func _return_to_camp_selection() -> void:
	if usable_camps.size() <= 0:
		end_turn()
		return
	Map.Player.current_state = Map.Player.player_state.SELECT_CAMP_FOR_ACTION

## TODO Implement this 
func _exit_menu() -> void:
	pass

func _load_menu() -> void:
	Map.load_menu()

func end_turn() -> void:
	if current_player_turn >= player_count:
		current_player_turn = 0
	else:
		current_player_turn += 1
	HUD.update_info_display("turn",0,current_player_turn+1)
	turn_end.emit(current_player_turn)
	_check_for_camp_spots()
	_reset_usable_camps()

func _reset_usable_camps() -> void:
	usable_camps = Map.Camps.get_usable_camps(current_player_turn)

func _send_score() -> void:
	HUD.set_score_display(current_player_turn, score_array[current_player_turn])

func _find_bones(bones : int) -> void:
	score_array[current_player_turn] += bones * 2
	HUD.update_info_display("bones", bones, current_player_turn+1)
	_send_score()

func _score_new_building() -> void:
	score_array[current_player_turn] +=1	
	HUD.update_info_display("encamp", 0,0)
	_send_score()
	
func _sabotage_punishment() -> void:
	var punishment = randi_range(0,4)
	score_array[current_player_turn] -= punishment
	HUD.update_info_display("sabotage", punishment, 0)
	_send_score()
	
signal turn_end
