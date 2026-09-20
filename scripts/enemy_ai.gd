extends Node

var my_turn = false
var my_available_camps : Array[Vector2i]
@export var Game : Node2D
@export var Map : Node2D

func choose_next_camp_AI(my_available_camp_locations : Array[Vector2i]) -> void:
	var next_camp = my_available_camp_locations.pick_random()
	#print("enemy camp locations ", my_available_camp_locations)
	Map.spawn_camp(next_camp)
	Game._score_new_building()
	#print("enemy encamping at ", next_camp)
	Game._score_new_building()

func choose_next_move_AI(get_my_available_moves) -> void:
	my_available_camps = get_my_available_moves
	for camp in my_available_camps:
		var chosen_move = "Pass"
		var move_loc : Vector2i
		var available_moves : Dictionary = Map.available_actions(camp)
		var has_sabotage : bool = !available_moves.get("Sabotage").is_empty()
		var has_dig : bool = !available_moves.get("Dig").is_empty()
		if has_dig && has_sabotage:
			chosen_move = ["Dig", "Sabotage"].pick_random()
			move_loc = available_moves.get(chosen_move).pick_random()
		elif has_dig:
			chosen_move = "Dig"
			move_loc = available_moves.get(chosen_move).pick_random()
		elif has_sabotage:
			chosen_move = "Sabotage"
			move_loc = available_moves.get(chosen_move).pick_random()
		_do_chosen_move(chosen_move, camp, move_loc)
		my_available_camps.erase(camp)
		#await get_tree().create_timer(1).timeout
	eai_done.emit()

func _do_chosen_move(move : String, camp : Vector2i, space : Vector2i) -> void:
	match move:
		"Sabotage":
			Map.destroy_digsite(space)
			Map.Camps.sleep_camp(camp, 1)
			Game._sabotage_punishment()
		"Pass":
			Map.Camps.sleep_camp(camp, 1)
		"Dig":
			Map.spawn_digsite(space, camp)
			Map.Camps.sleep_camp(camp, 1)
			

signal eai_done
