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

func board_init() -> void:
	board_node.tileSize = tile_height
	board_dict = board_node._init_board(board_width, board_height)
	board_node.redraw_board(board_dict)
	Player.tile_height = tile_height
	Player.w = board_width - 1
	Player.h = board_height - 1
	#initial p1 camp
	var v1 : Array[Vector2i] = [Vector2i(0,0)]
	player_location_array_dict[0] = v1
	var v2 : Array[Vector2i] = [Vector2i(board_width-1,board_height-1)]
	player_location_array_dict[1] = v2
	Camps.new_camp(0, Vector2i(0,0), false)
	#initial p2 camp
	Camps.new_camp(1, Vector2i(board_width-1,board_height-1), false)

func available_actions(selected_camp : Vector2i) -> Dictionary:
	var s : Array[Vector2i]
	var d : Array[Vector2i]
	var return_val : Dictionary = {
		"Sabotage" : s,
		"Dig" : d
	}
	var selected_camp_start : Array[Vector2i]
	selected_camp_start.append(selected_camp)
	var avail_range_sab = _get_display_range(3, selected_camp_start)
	for sab_option in avail_range_sab:
		if Camps.get_struct_at_location(sab_option) == "digsite" \
		&& Camps.player_structure_locations.get(sab_option).owning_player != current_player_turn:
			return_val["Sabotage"].append(sab_option)
	var avail_range_dig = _get_display_range(1, selected_camp_start)	
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
	var avail_range : Array[Vector2i] = _get_display_range(2, player_location_array_dict.get(current_player_turn))
	board_node.draw_range(avail_range, board_dict)

func display_range(r : int, p : Vector2i) -> void:
	var p_arr : Array[Vector2i] = [p]
	var avail_range = _get_display_range(r, p_arr)
	board_node.draw_range(avail_range, board_dict)

func undraw_range() -> void:
	board_node.undraw_range()

func spawn_digsite(selected_space : Vector2i, camp_space : Vector2i) -> void:
	if (Camps.get_struct_at_location(selected_space)) == "empty":
		Camps.instantiate_digsite(current_player_turn, selected_space, \
		camp_space, _tile_type_here(Player.curr_pos))

func destroy_digsite(coord : Vector2i) -> void:
	if (Camps.get_struct_at_location(coord)) == "digsite":
		Camps.destroy_digsite(coord, current_player_turn)

func spawn_camp(camp_coordinates) -> void:
	if (Camps.get_struct_at_location(camp_coordinates)) != "empty":
		return
	player_location_array_dict.get(current_player_turn).append(camp_coordinates)
	Camps.new_camp(current_player_turn, camp_coordinates)

func load_menu(acts_menu : Array[String]) -> void:
	var player_coords = Player.curr_pos
	player_menu = PLAYER_MENU.instantiate()
	player_menu.setup(acts_menu)
	player_menu.broadcast_menu_action.connect(get_parent()._on_broadcast_action)
	if player_coords.x < board_width/2:
		player_menu.position = Vector2i(3 * tile_height + tile_height, 0)
	else:
		player_menu.position = Vector2i(0, 0)
	add_child(player_menu)

func exit_menu() -> void:
	player_menu.queue_free()

func receive_end_turn(turn) -> void:
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
	#movement_range.append(start as Array[Vector2i])
	return _get_display_range(walkdist - 1, movement_range)

func _is_in_bounds(point : Vector2i) -> bool:
	if point.x >= board_width || point.x < 0 || point.y >= board_height || point.y < 0:
		return false
	return true

func _tile_type_here(coord : Vector2i) -> String:
	return board_dict.get(coord).tile_type

func _on_camps_spawn_hole(coord : Vector2i) -> void:
	board_dict[coord] = board_node.create_tile("hole")
	board_node.redraw_board(board_dict)

func _on_camps_spawn_camp(camp_type : String, coord : Vector2i) -> void:
	board_dict[coord] = board_node.create_tile(camp_type)
	print("spawn camp ", camp_type)
	board_node.redraw_board(board_dict)
