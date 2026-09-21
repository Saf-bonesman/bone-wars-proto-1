extends Node2D

@onready var HUD : Control = $HUD
@onready var Map : Node2D = $Map
@onready var Enemy : Node = $EnemyAI
var score_array : Array[int] = [0, 0]
var current_player_turn : int = 0
@export var player_count : int = 1
var last_selected_camp : Vector2i = Vector2i(0,0)
var available_actions : Dictionary
var usable_camps : Array[Vector2i]
var turn_counter : int = 1
var game_state : String

### test
#func _unhandled_input(_event: InputEvent) -> void:
	##pass
	#if Input.is_action_just_pressed("debug_middlemoues"):
		#print(Map.Player.current_state)
		#print(current_player_turn)
		#print(usable_camps)
		#print(last_selected_camp)
		#print(available_actions.get("Dig"))
		#print(available_actions.get("Sabotage"))
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
	Map.Camps.refresh_done.connect(_on_refresh)

func _restart_game() -> void:
	game_state = "active"
	score_array = [0, 0] #2 player scores
	turn_counter = 1
	current_player_turn = 0
	Map.board_init()
	HUD.init_player_displays()
	HUD.update_info_display("start",turn_counter,current_player_turn+1,0)
	_reset_usable_camps()
	Map.display_encamp_range()
	await get_tree().create_timer(3.0).timeout
	HUD.update_info_display("turn",turn_counter,current_player_turn+1,0)

func _on_broadcast_action(action_type : String) -> void:
	match action_type:
		"spawn_new_camp":
			_spawn_camp(Map.Player.curr_pos)
		"select_camp_for_action":
			_set_last_selected_camp()
			_select_camp_for_action_and_open_menu()
		"return_to_menu":
			Map.undraw_range()
			_select_camp_for_action_and_open_menu()
		"exit_menu":
			_set_player_state_to_select_camp()
			_exit_menu()
		"choose_dig":
			_set_player_state_to_dig()
		"choose_sabotage":
			_set_player_state_to_sabotage()
		"dig":
			_spawn_digsite()
		"sabotage":
			_do_sabotage()
		"pass_camp":
			_pass_camp()

func _unhandled_input(event: InputEvent) -> void:
	match game_state:
		#"active":
			#if event.is_action_pressed("action_start"):
				##_restart_game()	
				#HUD.update_info_display("restart",turn_counter,current_player_turn+1,0)
				#game_state = "pause"
				#print(game_state)
				#return
				## TODO display range?
		#"pause":
			#if event.is_action_pressed("action_start"):
				#_restart_game()	
				#print(game_state)
			#else:
				#game_state = "active"
				#return
		"end":
			if event.is_action_pressed("action_start"):
				_restart_game()	

func _check_for_camp_spots() -> void:
	Map.undraw_range()
	var available_camp_spots = Map.available_camp_spots()
	if available_camp_spots.is_empty():
		_no_available_spots_to_camp()
		return
	Map.display_encamp_range()
	Map.Player.change_state(Map.Player.player_state.SPAWN_NEW_CAMP)

func _spawn_camp(selected_location : Vector2i) -> void:
	var available_camp_spots = Map.available_camp_spots()
	if available_camp_spots.has(selected_location):
		Map.spawn_camp(selected_location)
		_score_new_building()
		_set_player_state_to_select_camp()

func _set_player_state_to_select_camp() -> void:
		Map.undraw_range()
		Map.Player.change_state(Map.Player.player_state.SELECT_CAMP_FOR_ACTION)
		HUD.update_info_display("camping",turn_counter,current_player_turn+1,usable_camps.size())

func _set_player_state_to_dig() -> void:
	_exit_menu()
	Map.display_range(1,last_selected_camp)
	Map.Player.change_state(Map.Player.player_state.ACTION_DIG)
	HUD.update_info_display("dig",turn_counter,current_player_turn+1,0)

func _set_player_state_to_sabotage() -> void:
	_exit_menu()
	Map.display_range(3,last_selected_camp)	
	Map.Player.change_state(Map.Player.player_state.ACTION_SABOTAGE)
	HUD.update_info_display("choose_sab",turn_counter,current_player_turn+1,0)

func _no_available_spots_to_camp() -> void:
	Map.Player.change_state(Map.Player.player_state.SELECT_CAMP_FOR_ACTION)

func _set_last_selected_camp() -> void:
	if (!usable_camps.has(Map.Player.curr_pos)):
		pass
	last_selected_camp = Map.Player.curr_pos
	available_actions = Map.available_actions(last_selected_camp)

func _pass_camp() -> void:
	_exit_menu()
	_set_camp_to_sleep()

func _set_camp_to_sleep() -> void:
	usable_camps.erase(last_selected_camp)
	Map.Camps.sleep_camp(last_selected_camp, current_player_turn)
	if usable_camps.is_empty():
		end_turn()
		return
	Map.Player.change_state(Map.Player.player_state.SELECT_CAMP_FOR_ACTION)
	HUD.update_info_display("camping",turn_counter,current_player_turn+1,usable_camps.size())

func _clear_available_actions() -> void:
	available_actions["Sabotage"].clear()
	available_actions["Dig"].clear()

func _select_camp_for_action_and_open_menu() -> void:
	if !usable_camps.has(last_selected_camp):
		return
	var actions_for_menu : Array[String]
	if !available_actions.get("Sabotage").is_empty():
		actions_for_menu.append("Sabotage")
	if !available_actions.get("Dig").is_empty():
		actions_for_menu.append("Dig")
	actions_for_menu.append("Pass")
	actions_for_menu.append("Back")
	#print(actions_for_menu)
	Map.Player.change_state(Map.Player.player_state.MENUING)
	_load_menu(actions_for_menu) # open menu here with the options in this array

func _spawn_digsite() -> void:
	var selected_space = Map.Player.curr_pos
	if available_actions.size() == 0:
		return
	if (available_actions.get("Dig").has(selected_space)):
		Map.spawn_digsite(selected_space, last_selected_camp)
		_clear_available_actions()
		Map.undraw_range()
		_set_camp_to_sleep()

func _do_sabotage() -> void:
	var selected_space = Map.Player.curr_pos
	if (available_actions.get("Sabotage").has(selected_space)):
		Map.destroy_digsite(selected_space)
		_clear_available_actions()
		Map.undraw_range()
		_sabotage_punishment()
		await get_tree().create_timer(3.0).timeout
		_set_camp_to_sleep()

func _return_to_camp_selection() -> void:
	if usable_camps.size() <= 0:
		end_turn()
		return
	Map.Player.change_state(Map.Player.player_state.SELECT_CAMP_FOR_ACTION)

# Unloads player menu instance
func _exit_menu() -> void:
	Map.exit_menu()
	_return_to_camp_selection()

func _load_menu(acts_menu : Array[String]) -> void:
	Map.load_menu(acts_menu)

func end_turn() -> void:
	if current_player_turn >= player_count:
		current_player_turn = 0
		turn_counter += 1
	else:
		current_player_turn += 1
		Map.Player.my_turn = false
	if turn_counter > 10:
		_finish_game()
		return
	HUD.update_info_display("start",turn_counter,current_player_turn+1,0)
	Map.receive_end_turn(current_player_turn)
	_check_for_camp_spots()
	Map.Camps.continue_all_camps(current_player_turn)
	_reset_usable_camps()
	await get_tree().create_timer(4.0).timeout
	if (current_player_turn == 1):
		_enter_enemy_phase()
	else:
		HUD.update_info_display("turn",turn_counter,current_player_turn+1,0)

func _on_refresh() -> void:
	_reset_usable_camps()

func _reset_usable_camps() -> void:
	usable_camps = Map.Camps.get_usable_camps(current_player_turn)
	#print(usable_camps)

func _send_score() -> void:
	HUD.set_score_display(current_player_turn, score_array[current_player_turn])

func _find_bones(bones : int) -> void:
	score_array[current_player_turn] += bones * 2
	HUD.update_info_display("bones",turn_counter,current_player_turn+1,bones)
	_send_score()
	await get_tree().create_timer(3.0).timeout
	HUD.update_info_display("turn",turn_counter,current_player_turn+1,0)
	

func _score_new_building() -> void:
	score_array[current_player_turn] +=1	
	_send_score()

func _sabotage_punishment() -> void:
	var punishment = randi_range(0,4)
	score_array[current_player_turn] -= punishment
	HUD.update_info_display("sabotage",0,0,punishment)
	_send_score()

func _finish_game() -> void:
	var winner : int
	if score_array[0] > score_array[1]:
		winner = 1
	else:
		winner = 2
	HUD.update_info_display("gameend",0,winner,score_array[winner - 1])
	game_state = "end"

func _on_enemy_ai_eai_done() -> void:
	Map.Player.my_turn = true
	end_turn()

func _enter_enemy_phase() -> void:
	Map.undraw_range()
	HUD.update_info_display("enemy",turn_counter,current_player_turn+1,3)
	Enemy.choose_next_camp_AI(Map.available_camp_spots())
	_reset_usable_camps()
	Enemy.choose_next_move_AI(usable_camps)
