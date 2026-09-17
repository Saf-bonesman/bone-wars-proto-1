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
		local.erase(point)
	for cell in local:
		view_range.set_cell(cell, 0, board.get(cell).type_id, 0)

func undraw_range() -> void:
	view_range.clear()

## actually draw the tile
func redraw_board(board : Dictionary) -> void:
	for cell in board:
		terrain.set_cell(cell, 0, board.get(cell).type_id, 0)

## inner class holding tile type info
## only use this for base tiles
class Tile:
	const terrainDict : Dictionary = {
		"meadow" = [Vector2i(3,0), Vector2i(4,0), Vector2i(5,0), Vector2i(6,0)],
		"wastes" = [Vector2i(3,1), Vector2i(4,1), Vector2i(5,1), Vector2i(6,1)],
		"bones" = [Vector2i(3,2), Vector2i(4,2), Vector2i(5,2), Vector2i(6,2), Vector2i(7,2)]
	}
	var loc : Marker2D
	var tile_type : String = "wastes"
	var type_id : Vector2i = terrainDict.get(tile_type).pick_random()

	func randomize_cell_type() -> void:
		var rando = terrainDict.keys()[randi() % terrainDict.size()]
		tile_type = rando
		type_id = terrainDict.get(tile_type).pick_random()
	
