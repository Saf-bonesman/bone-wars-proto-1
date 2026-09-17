extends Node

var is_active : bool = false
@export var my_turn : int = 1
var Map : Node2D
var camps : Dictionary = {
	"Active" = [],
	"Inactive" = []
}

func _ready() -> void:
	Map = get_parent()

func _process(delta: float) -> void:
	pass

func _place_new_camp() -> void:
	pass

func _decide_action(camp : Vector2i) -> String:
	var diggable_spaces : Array[Vector2i] = _get_spaces_with(camp, 1, "none")
	var sabotagable_spaces : Array[Vector2i] = _get_spaces_with(camp, 3, "digsite")
	if _can_do_thing(diggable_spaces):
		pass
	if _can_do_thing(sabotagable_spaces):
		pass
	return "skip_camp"

func _can_do_thing(available : Array[Vector2i]) -> bool:
	if available.is_empty():
		return false
	return true

func _get_spaces_with(camp : Vector2i, range : int, searchfor : String) -> Array[Vector2i]:
	var spaces_in_range : Array[Vector2i] = Map.get_display_range(range, [camp])
	var spaces_with : Array[Vector2i] = Map.get_spaces_info(spaces_in_range, searchfor)
	return spaces_with
