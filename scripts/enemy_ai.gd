extends Node

var my_turn = false
var my_available_camps : Array[Vector2i]
@export var Game : Node2D
@export var Map : Node2D
@export var HUD : Control
@export var cursor_sprite : AnimatedSprite2D

func choose_next_camp_AI(my_available_camp_locations : Array[Vector2i]) -> void:
	var next_camp = my_available_camp_locations.pick_random()
	#print("enemy camp locations ", my_available_camp_locations)
	Map.spawn_camp(next_camp)
	#print("enemy encamping at ", next_camp)
	Game._score_new_building()
	cursor_sprite.set_visible(true)
	cursor_sprite.play("evil", .5, false)
	cursor_sprite.position = next_camp * Vector2i(16,16) + Vector2i(24,8)

func choose_next_move_AI(get_my_available_moves) -> void:
	await get_tree().create_timer(1.0).timeout
	print(get_my_available_moves)
	my_available_camps = get_my_available_moves
	while my_available_camps.size() > 0:
		var chosen_move = "Pass"
		var move_loc : Vector2i
		var camp = my_available_camps.pop_front()
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
		cursor_sprite.position = camp * Vector2i(16,16) + Vector2i(24,8)
		#print(cursor_sprite.position)
		_do_chosen_move(chosen_move, camp, move_loc)
		#print(my_available_camps)
		await get_tree().create_timer(1.0).timeout
	cursor_sprite.set_visible(false)
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
