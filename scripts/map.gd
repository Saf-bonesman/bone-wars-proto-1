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

var player_menu
var PLAYER_MENU = preload("res://scenes/PlayerMenu.tscn")

func _ready() -> void:
	board_init()
	
func board_init() -> void:
	board_node.tileSize = tile_height
	board_dict = board_node._init_board(board_width, board_height)
	board_node.redraw_board(board_dict)
	Player.tile_height = tile_height
	Player.w = board_width - 1
	Player.h = board_height - 1

func spawn_camp():
	if is_instance_valid(player_menu):
		player_menu.queue_free()
	var camp_coordinates = Player.curr_pos
	if player_structures.has(camp_coordinates):
		return
	player_structures[camp_coordinates] = "camp"+str(current_player_turn)
	Camps.draw_new_struct(player_structures.get(camp_coordinates), camp_coordinates)

func spawn_menu(coords : Vector2i) -> void:
	print(coords.x)
	player_menu = PLAYER_MENU.instantiate()
	add_child(player_menu)
	if coords.x < 4:
		player_menu.position = Vector2i(3 * tile_height + tile_height, 0)
	else:
		player_menu.position = Vector2i(0, 0)

func _on_game_turn_end(turn) -> void:
	current_player_turn = turn # Replace with function body.
