extends Node2D

@export var board_width : int = 8
@export var board_height : int = 6
const tile_height = 16
@onready var board_node : Node2D = $Board
var board_dict : Dictionary
#var board_dict_prev : Dictionary
@onready var Player : Node2D = $Player
@onready var Camps : Node2D = $Camps
var player_structures : Dictionary = {}
var current_player_turn = 0

func board_init() -> void:
	board_node.tileSize = tile_height
	board_dict = board_node._init_board(board_width, board_height)
	board_node.redraw_board(board_dict)
	Player.tile_height = tile_height
	Player.w = board_width - 1
	Player.h = board_height - 1

func display_range(r : int, p : Vector2i) -> void:
	var avail_range = _get_display_range(r, [p])
	board_node.draw_range(avail_range, board_dict)

func undraw_range() -> void:
	board_node.undraw_range()

func spawn_camp():
	var camp_coordinates = Player.curr_pos
	if player_structures.has(camp_coordinates):
		return
	player_structures[camp_coordinates] = "camp"+str(current_player_turn)
	Camps.draw_new_struct(player_structures.get(camp_coordinates), camp_coordinates)

func _on_game_turn_end(turn) -> void:
	current_player_turn = turn # Replace with function body.

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
