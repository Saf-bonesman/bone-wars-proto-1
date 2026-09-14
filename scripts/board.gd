extends Node2D

## generates and draws a board state
@export var terrain : TileMapLayer
var tileSize
const terrainDict : Dictionary = {
	"wastes" = 0,
	"bones" = 1
}

func _init_board(board_width, board_height) -> Dictionary:
	var board : Dictionary = {}
	for x in range(board_width):
		for y in range(board_height):
			var Cell = Tile.new()
			var Location = Marker2D.new()
			Location.position.y = y * tileSize
			Location.position.x = x * tileSize
			board[Vector2i (x,y)] = Cell
	return board

## actually draw the tile
func redraw_board(board : Dictionary) -> void:
	for cell in board:
		var terrainIndex = terrainDict.get(board.get(cell).TileType)
		terrain.set_cell(cell, terrainIndex, Vector2i(0,0), 0)

## inner class holding tile type info
## only use this for base tiles
class Tile:
	var Location : Marker2D
	var TileType : String = "wastes"
	var TileSprite : Sprite2D
