extends Node2D

## generates and draws a board state
@export var board_width : int = 10
@export var board_height : int = 7
@export var terrain : TileMapLayer
const tileSize = 16
var board : Dictionary = {}
const terrainDict : Dictionary = {
	"wastes" = 0,
	"bones" = 1
}

func _ready() -> void:
	_init_board()
	redraw_board()

func _init_board() -> void:
	for x in range(board_width):
		for y in range(board_height):
			var Cell = Tile.new()
			var Location = Marker2D.new()
			Location.position.y = y * tileSize
			Location.position.x = x * tileSize
			board[Vector2i (x,y)] = Cell

## actually draw the tiles
func redraw_board() -> void:
	for cell in board:
		var terrainIndex = terrainDict.get(board.get(cell).TileType)
		terrain.set_cell(cell, terrainIndex, Vector2i(0,0), 0)

## inner class holding tile type info
## only use this for base tiles
class Tile:
	var Location : Marker2D
	var TileType : String = "wastes"
	var TileSprite : Sprite2D
