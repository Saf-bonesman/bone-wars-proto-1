extends Node2D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

@export var board_width : int = 8
@export var board_height : int = 6
const tile_height = 16
@onready var board_node : Node2D = $Board
var board_dict : Dictionary
@onready var Player : Node2D = $Player

func _ready() -> void:
	board_node.tileSize = tile_height
	board_dict = board_node._init_board(board_width, board_height)
	board_node.redraw_board(board_dict)
	Player.tile_height = tile_height
	Player.w = board_width - 1
	Player.h = board_height - 1
