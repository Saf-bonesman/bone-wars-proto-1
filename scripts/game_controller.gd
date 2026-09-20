extends Node2D

@onready var HUD : Control = $HUD
@onready var Map : Node2D = $Map
var score_array : Array[int] = [0, 0, 0, 0, 0]
var current_player_turn : int = 0
@export var player_count : int = 1



## test
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_middlemoues"):
		_restart_game()
	if Input.is_action_just_pressed("debug_rightmouse"):
		end_turn()
	if Input.is_action_just_pressed("debug_key_1"):
		Map.display_range(1, Map.Player.curr_pos)
	if Input.is_action_just_pressed("debug_key_2"):
		Map.display_range(2, Map.Player.curr_pos)
	if Input.is_action_just_pressed("debug_key_3"):
		Map.display_range(3, Map.Player.curr_pos)
	if Input.is_action_just_pressed("debug_key_4"):
		Map.undraw_range()
	##if Input.is_action_just_pressed("action_left"):
	##	_sabotage_punishment()
	##if Input.is_action_just_pressed("action_up"):
	##	_score_new_building()

func _ready() -> void:
	_restart_game()
	Map.Player.broadcast_action.connect(_on_broadcast_action)

func _restart_game() -> void:
	score_array = [0, 0, 0, 0, 0]
	current_player_turn = 0
	Map.board_init()
	Map.display_encamp_range()
	HUD.init_player_displays()

func _on_broadcast_action(action_type : String) -> void:
	print(action_type)
	match action_type:
		"choose_camp_loc":
			_phase_encamp()
		"encamp":
			_phase_choose_camp()
			print(Map.available_actions(Map.Player.curr_pos))
		"dig":
			_spawn_digsite()
		"destroy":
			_destroy_digsite()
		"menu":
			_load_menu()

func _phase_encamp():
	Map.undraw_range()
	Map.display_encamp_range()

func _phase_choose_camp():
	Map.undraw_range()
	Map.spawn_camp()

func _spawn_digsite():
	Map.spawn_digsite()

func _destroy_digsite():
	Map.destroy_digsite()
	
func _load_menu():
	Map.load_menu()

func end_turn() -> void:
	if current_player_turn >= player_count:
		current_player_turn = 0
	else:
		current_player_turn += 1
	HUD.update_info_display("turn",0,current_player_turn+1)
	turn_end.emit(current_player_turn)

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
