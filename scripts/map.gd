extends Node2D

@export var board_width : int = 8
@export var board_height : int = 6
const tile_height = 16
@onready var board_node : Node2D = $Board
var board_dict : Dictionary
#var board_dict_prev : Dictionary
@onready var Player : Node2D = $Player
@onready var Camps : Node2D = $Camps
var current_player_turn = 0
var selected_camp_coordinates : Vector2i = Vector2i(2,2)
var player_location_array_dict : Dictionary = {}

var player_menu
var PLAYER_MENU = preload("res://scenes/PlayerMenu.tscn")

func _ready() -> void:
	#initial p1 camp
	var v1 : Array[Vector2i] = [Vector2i(0,0)]
	player_location_array_dict[0] = v1
	var v2 : Array[Vector2i] = [Vector2i(board_width-1,board_height-1)]
	player_location_array_dict[1] = v2
	Camps.new_camp(0, Vector2i(0,0), false)
	#initial p2 camp
	Camps.new_camp(1, Vector2i(board_width-1,board_height-1), false)

func board_init() -> void:
	board_node.tileSize = tile_height
	board_dict = board_node._init_board(board_width, board_height)
	board_node.redraw_board(board_dict)
	Player.tile_height = tile_height
	Player.w = board_width - 1
	Player.h = board_height - 1

func available_actions(selected_camp : Vector2i) -> Dictionary:
	var return_val : Dictionary = {
		"Sabotage" : [],
		"Dig" : []
	}
	var avail_range_sab = _get_display_range(3, [selected_camp])
	for sab_option in avail_range_sab:
		if Camps.get_struct_at_location(sab_option) == "digsite":
			return_val["Sabotage"].append(sab_option)
	var avail_range_dig = _get_display_range(1, [selected_camp])	
	for dig_option in avail_range_dig:
		if Camps.get_struct_at_location(dig_option) == "empty":
			return_val["Dig"].append(dig_option)
	return return_val

func available_camp_spots() -> Array[Vector2i]:
	var return_val : Array[Vector2i]
	var avail_range = _get_display_range(2, player_location_array_dict.get(current_player_turn))
	for camp_option in avail_range:
		if Camps.get_struct_at_location(camp_option) == "empty":
			return_val.append(camp_option)
	return return_val


func display_encamp_range() -> void:
	var avail_range = _get_display_range(2, player_location_array_dict.get(current_player_turn))
	board_node.draw_range(avail_range, board_dict)

func display_range(r : int, p : Vector2i) -> void:
	var avail_range = _get_display_range(r, [p])
	board_node.draw_range(avail_range, board_dict)

func undraw_range() -> void:
	board_node.undraw_range()

func spawn_digsite() -> void:
	if (Camps.get_struct_at_location(Player.curr_pos)) == "empty":
		Camps.instantiate_digsite(current_player_turn, Player.curr_pos, \
		selected_camp_coordinates, _tile_type_here(Player.curr_pos))

func destroy_digsite() -> void:
	player_menu.queue_free()
	if (Camps.get_struct_at_location(Player.curr_pos)) == "digsite":
		Camps.destroy_digsite(Player.curr_pos, current_player_turn)

func spawn_camp() -> void:
	if (Camps.get_struct_at_location(Player.curr_pos)) != "empty":
		return
	var camp_coordinates = Player.curr_pos
	player_location_array_dict.get(current_player_turn).append(camp_coordinates)
	Camps.new_camp(current_player_turn, camp_coordinates)

func load_menu() -> void:
	var player_coords = Player.curr_pos
	player_menu = PLAYER_MENU.instantiate()
	if player_coords.x < 4:
		player_menu.position = Vector2i(3 * tile_height + tile_height, 0)
	else:
		player_menu.position = Vector2i(0, 0)
	add_child(player_menu)

func _on_game_turn_end(turn) -> void:
	current_player_turn = turn
	Camps.refresh(current_player_turn)

## this is the first time I've used a recursive function since uni btw
func _get_display_range(walkdist : int, start : Array[Vector2i]) -> Array[Vector2i]:
	if walkdist <= 0: 
		return start
	const directions : Array[Vector2i] = [
		Vector2i.UP,
		Vector2i.DOWN,
		Vector2i.LEFT,
		Vector2i.RIGHT
	]
	var movement_range : Array[Vector2i] = start.duplicate(false)
	for d in directions:
		for point in start:
			#print(point)
			var next = point+d
			if !movement_range.has(next) \
			&& _is_in_bounds(next):
				movement_range.append(next)
	movement_range.append(start)
	return _get_display_range(walkdist - 1, movement_range)

func _is_in_bounds(point : Vector2i) -> bool:
	if point.x > board_width || point.x < 0 || point.y > board_height || point.y < 0:
		return false
	return true

func _tile_type_here(coord : Vector2i) -> String:
	return board_dict.get(coord).tile_type

func _on_camps_spawn_hole(loc : Vector2i) -> void:
	board_dict[loc] = board_node.create_tile("hole")
	board_node.redraw_board(board_dict)
	
