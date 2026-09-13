extends Node2D

@export var board_width : int = 8
@export var board_height : int = 6
const tile_height = 16
@onready var board_node : Node2D = $Board
var board_dict : Dictionary
@onready var Player : Node2D = $Player
@onready var Camps : Node2D = $Camps
var player_structures : Dictionary = {}
var current_player_turn = 0

func _ready() -> void:
	board_init()
	
func board_init() -> void:
	board_node.tileSize = tile_height
	board_dict = board_node._init_board(board_width, board_height)
	board_node.redraw_board(board_dict)
	Player.tile_height = tile_height
	Player.w = board_width - 1
	Player.h = board_height - 1

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_leftmouse"):
		spawn_camp()

func spawn_camp():
	var camp_coordinates = Player.curr_pos
	if player_structures.has(camp_coordinates):
		return
	player_structures[camp_coordinates] = "camp"+str(current_player_turn)
	Camps.draw_new_struct(player_structures.get(camp_coordinates), camp_coordinates)

func _on_game_turn_end(turn) -> void:
	current_player_turn = turn # Replace with function body.
