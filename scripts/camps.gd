extends Node2D

@onready var structure_map : TileMapLayer = $PlayerStructureTiles
var digsite_scene : PackedScene = load("res://scenes/dig_site.tscn")
@onready var digsites : Node2D = $Digsites

const structure_dict : Dictionary = {
	"camp0" = Vector2i(0,0),
	"camp1" = Vector2i(0,1)
}

func instantiate_digsite(player : int, struct_coord : Vector2i) -> void:
	var dig : Node2D = digsite_scene.instantiate()
	print("spawn digsite(camps)")
	dig.owning_player = player
	dig.position = struct_coord * Vector2i(16,16)
	digsites.add_child(dig)

func draw_new_struct(struct_type : String, struct_coord : Vector2i):
	var tileIdx = structure_dict.get(struct_type)
	structure_map.set_cell(struct_coord, 0, tileIdx, 0)

func draw_all_structs(structs : Dictionary):
	for coordinate in structs:
		var tileIdx = structure_dict.get(structs.get(coordinate))
		structure_map.set_cell(coordinate, 0, tileIdx, 0)
