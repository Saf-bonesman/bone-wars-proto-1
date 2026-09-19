extends Node2D

##this controls player structures (digsites and camps)
##camps are drawn using a tilemap
##digsites are scenes
##a dugsite is also a scene but it just plays an animation then 
## then deletes itself

@onready var structure_map : TileMapLayer = $PlayerStructureTiles
var digsite_scene : PackedScene = load("res://scenes/dig_site.tscn")
var dugsite_scene : PackedScene = load("res://scenes/dug_site.tscn")
var eepy_scene : PackedScene = load("res://scenes/eepy_indicator.tscn")
@onready var digsites : Node2D = $Digsites
## dugsites are the explosion animation,
## when the explosion animation finishes it emits a signal
## which causes the Map node to draw a hole
@onready var dugsites : Node2D = $Dugsites
## eepies are indicators for a camp being inactive
@onready var eepies : Node2D = $Eeepies

const structure_dict : Dictionary = {
	"camp0" = Vector2i(1,0),
	"camp1" = Vector2i(1,1)
}

var player_structure_locations : Dictionary = {}
var digsite_holder : Dictionary = {}

func get_struct_at_location(coord : Vector2i) -> String:
	if player_structure_locations.has(coord):
		return player_structure_locations.get(coord).type
	return "empty"

func destroy_digsite(coord : Vector2i, player : int) -> void:
	if !player_structure_locations.has(coord) \
	|| player_structure_locations.get(coord).type != "digsite" \
	|| player_structure_locations.get(coord).owning_player == player:
		return
	var psti = PlayerStructureTypeInfo.new()
	psti.type = "dugsite"
	player_structure_locations[coord] = psti
	digsite_holder.get(coord).end_digsite(true)
	var dug : Node2D = dugsite_scene.instantiate()
	dug.position = coord * Vector2i(16,16)
	dug.digsite_animation_complete.connect(_on_digsite_animation_complete)
	dug.loc = coord
	dugsites.add_child(dug)

func sleep_camp(coord : Vector2i, player_turn : int) -> void:
	player_structure_locations.get(coord).active = false
	var eepy : Node2D = eepy_scene.instantiate()
	eepy.position = coord * Vector2i(16,16)
	eepy.coord = coord
	eepy.owning_player = player_turn
	eepies.add_child(eepy)

func refresh(player_turn : int) -> void:
	for eepy in eepies.get_children():
		if eepy.owning_player == player_turn:
			eepy.queue_free()

func _on_digsite_animation_complete(loc : Vector2i) -> void:
	print("spawn")
	spawn_hole.emit(loc)

func instantiate_digsite(player : int, struct_coord : Vector2i, \
camp_selected : Vector2i, bones_type : String) -> void:
	var dig : Node2D = digsite_scene.instantiate()
	dig.owning_player = player
	dig.position = struct_coord * Vector2i(16,16)
	dig.my_location = struct_coord
	dig.owning_camp = camp_selected
	dig.dig_type = bones_type
	digsites.add_child(dig)
	digsite_holder[struct_coord] = dig
	var psti = PlayerStructureTypeInfo.new()
	psti.owning_player = player
	psti.type = "digsite"
	player_structure_locations[struct_coord] = psti

func new_camp(turn : int, coordinates: Vector2i, inactivate : bool = true):
	_draw_new_struct("camp"+str(turn), coordinates)
	var psti = PlayerStructureTypeInfo.new()
	psti.type = "camp"
	player_structure_locations[coordinates] = psti
	if inactivate:
		sleep_camp(coordinates, turn)

func _draw_new_struct(struct_type : String, struct_coord : Vector2i):
	var tileIdx = structure_dict.get(struct_type)
	structure_map.set_cell(struct_coord, 0, tileIdx, 0)
	player_structure_locations[struct_coord] = struct_type
	
signal spawn_hole

class PlayerStructureTypeInfo:
	var owning_player : int
	var type : String
	var active : bool = true
	var digging : bool = false
