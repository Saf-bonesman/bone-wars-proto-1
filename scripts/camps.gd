extends Node2D

@onready var structure_map : TileMapLayer = $PlayerStructureTiles
var digsite_scene : PackedScene = load("res://scenes/dig_site.tscn")
var dugsite_scene : PackedScene = load("res://scenes/dug_site.tscn")
@onready var digsites : Node2D = $Digsites
@onready var dugsites : Node2D = $Dugsites

const structure_dict : Dictionary = {
	"camp0" = Vector2i(0,0),
	"camp1" = Vector2i(0,1)
}

var player_structure_locations : Dictionary = {}
var digsite_holder : Dictionary = {}

func get_struct_at_location(coord : Vector2i) -> String:
	if player_structure_locations.has(coord):
		return player_structure_locations.get(coord)
	return "empty"

func destroy_digsite(coord : Vector2i, turn : int) -> void:
	if !player_structure_locations.has(coord) \
	|| player_structure_locations.get(coord) != "digsite"+str(turn):
		return
	player_structure_locations[coord] = "dugsite"
	digsite_holder.get(coord).end_digsite(true)
	var dug : Node2D = dugsite_scene.instantiate()
	dug.position = coord * Vector2i(16,16)
	dug.digsite_animation_complete.connect(_on_digsite_animation_complete)
	dug.loc = coord
	dugsites.add_child(dug)

func _on_digsite_animation_complete(loc : Vector2i) -> void:
	print("spawn")
	spawn_hole.emit(loc)

func instantiate_digsite(player : int, struct_coord : Vector2i) -> void:
	var dig : Node2D = digsite_scene.instantiate()
	dig.owning_player = player
	dig.position = struct_coord * Vector2i(16,16)
	digsites.add_child(dig)
	digsite_holder[struct_coord] = dig
	player_structure_locations[struct_coord] = "digsite"+str(player)

func draw_new_struct(struct_type : String, struct_coord : Vector2i):
	var tileIdx = structure_dict.get(struct_type)
	structure_map.set_cell(struct_coord, 0, tileIdx, 0)
	player_structure_locations[struct_coord] = struct_type

func draw_all_structs(structs : Dictionary):
	for coordinate in structs:
		var tileIdx = structure_dict.get(structs.get(coordinate))
		structure_map.set_cell(coordinate, 0, tileIdx, 0)

signal spawn_hole
