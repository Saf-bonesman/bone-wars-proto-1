extends Node2D

@onready var structure_map : TileMapLayer = $PlayerStructureTiles

const structure_dict : Dictionary = {
	"camp0" = 1,
	"camp1" = 2
}

func draw_new_struct(struct_type : String, struct_coord : Vector2i):
	var tileIdx = structure_dict.get(struct_type)
	structure_map.set_cell(struct_coord, tileIdx, Vector2i(0,0), 0)

func draw_all_structs(structs : Dictionary):
	for coordinate in structs:
		var tileIdx = structure_dict.get(structs.get(coordinate))
		structure_map.set_cell(coordinate, tileIdx, Vector2i(0,0), 0)
