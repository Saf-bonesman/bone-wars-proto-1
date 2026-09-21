extends Node2D

## generates and draws a board state
@export var terrain : TileMapLayer
@export var view_range : TileMapLayer
@export var grid : TileMapLayer
var tileSize

func _init_board(board_width, board_height) -> Dictionary:
	var board : Dictionary = {}
	for x in range(board_width):
		for y in range(board_height):
			var Cell = Tile.new()
			Cell.randomize_cell_type()
			board[Vector2i (x,y)] = Cell
	return board

func draw_range(r : Array[Vector2i], board):
	var local = board.duplicate(false)
	view_range.clear()
	for point in r:
		local.erase(point) #might need to refactor? unsure
	for cell in local:
		view_range.set_cell(cell, 0, board.get(cell).type_id, 0)

func undraw_range() -> void:
	view_range.clear()

## actually draw the tile
func redraw_board(board : Dictionary) -> void:
	for cell in board:
		terrain.set_cell(cell, 0, board.get(cell).type_id, 0)

func create_tile(this_tile_type : String) -> Tile:
	var return_tile = Tile.new()
	return_tile.tile_type = this_tile_type
	return_tile.randomize_cell_art()
	return return_tile

## inner class holding tile type info
## only use this for base tiles
class Tile:
	const starting_tiles = ["meadow", "wastes", "bones"]
	const terrainDict : Dictionary = {
		"meadow" = [Vector2i(3,0), Vector2i(4,0), Vector2i(5,0), Vector2i(6,0)],
		"wastes" = [Vector2i(3,1), Vector2i(4,1), Vector2i(5,1), Vector2i(6,1)],
		"hole" = [Vector2i(3,3),Vector2i(4,3),Vector2i(3,4)],
		"bones" = [Vector2i(3,2), Vector2i(4,2), Vector2i(5,2), Vector2i(6,2), Vector2i(7,2)],
		"camp0" = [Vector2i(1,0)],
		"camp1" = [Vector2i(1,1)]
	}
	var loc : Marker2D
	var tile_type : String = "wastes"
	var type_id : Vector2i = terrainDict.get(tile_type).pick_random()

	func randomize_cell_art() -> void:
		type_id = terrainDict.get(tile_type).pick_random()

	func randomize_cell_type() -> void:
		var rando = starting_tiles[randi() % starting_tiles.size()]
		tile_type = rando
		type_id = terrainDict.get(tile_type).pick_random()
