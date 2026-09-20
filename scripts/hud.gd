extends Control

@onready var player1_score : Label = $PlayerDisplay/ScoreDisplay
@onready var player2_score : Label = $PlayerDisplay2/ScoreDisplay
@onready var player1_label : Label = $PlayerDisplay/PlayerNumber
@onready var player2_label : Label = $PlayerDisplay2/PlayerNumber
@onready var info_disp : Label = $InfoDisplay

var intro_snippet : Array[String] = ["Get paleontologing!", "Bones is power", \
"Industrial evolution", "Count your raptors\n before they hatch"]

var sab_snippet : Array[String] = ["Probably just teeth.", "Break 'em to make 'em!", \
"Amateur saboteur~", "Paleollateral damage"]

func init_player_displays() -> void:
	player1_label.text = "P1"
	player2_label.text = "P2"
	player1_score.text = "00"
	player2_score.text = "00"

func update_info_display(type : String, num : int, player : int) -> void:
	var text_to_update : String = ""
	match type:
		"bones":
			text_to_update = "Player " + str(player) + "\n Dug up " + str(num) + " bones"
		"sabotage":
			match num:
				0:
					text_to_update = "Sneaky devil."+str(num)+"\n REP lost"
				6:
					text_to_update = "You're exposed!"+str(num)+"\n REP lost"
				_:
					var random_text: String = sab_snippet.pick_random()
					text_to_update = random_text+"\n REP lost"
		"start":
			var random_text: String = intro_snippet.pick_random()
			text_to_update = random_text
		"turn":
			match num:
				9:
					text_to_update = "Player "+str(player)+"\nFinal turn!"
				_:
					text_to_update = "Player "+str(player)+", turn "+str(num)+"\nPlace new camp"
		"camping":
			text_to_update = "Player "+str(player)+"\nSelect camp to action"
		"gameend":
			text_to_update = "P"+str(player)+" wins!\nPress space encamp anew"
	info_disp.text = text_to_update

## refactor this later, or don't
func set_score_display( playerNumber : int, score : int ):
	var string_score
	if score<10:
		string_score = "0"+str(score)
	else:
		string_score = str(score)
	if playerNumber == 0:
		player1_score.text = string_score
	if playerNumber == 1:
		player2_score.text = string_score
