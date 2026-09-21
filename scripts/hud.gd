extends Control

@onready var player1_score : Label = $PlayerDisplay/ScoreDisplay
@onready var player2_score : Label = $PlayerDisplay2/ScoreDisplay
@onready var player1_label : Label = $PlayerDisplay/PlayerNumber
@onready var player2_label : Label = $PlayerDisplay2/PlayerNumber
@onready var info_disp : Label = $InfoDisplay

var intro_snippet : Array[String] = ["Get paleontologing!", "Bones is power", \
"Industrial evolution.", "Count your raptors\n before they hatch"]

var sab_snippet : Array[String] = ["Probably just teeth.", "Break it to make it!", \
"Amateur saboteur", "Paleollateral damage"]

func init_player_displays() -> void:
	player1_label.text = "P1"
	player2_label.text = "P2"
	player1_score.text = "00"
	player2_score.text = "00"

func update_info_display(type : String, turn : int, player : int, num : int) -> void:
	var player_snippet : String = "Player "+str(player)+", turn "+str(turn)
	var text_to_update : String = ""
	match type:
		"bones":
			text_to_update = player_snippet+"\nDug up " + str(num) + " bones"
		"sabotage":
			match num:
				0:
					text_to_update = "Sneaky devil.\n"+str(num)+" REP lost"
				4:
					text_to_update = "You're exposed!\n"+str(num)+" REP lost"
				_:
					var random_text: String = sab_snippet.pick_random()
					text_to_update = random_text+"\n"+str(num)+" REP lost"
		"start":
			var random_text: String = intro_snippet.pick_random()
			text_to_update = random_text
		"turn":
			match num:
				9:
					text_to_update = player_snippet+"\nLast camp!"
				_:
					text_to_update = player_snippet+"\nPlace new camp"
		"enemy":
			match num:
				3:
					text_to_update = player_snippet+"\nThinking..."
				2:
					text_to_update = player_snippet+"\nThinking.."
				1:
					text_to_update = player_snippet+"\nThinking."
		"camping":
			match num:
				1:
					text_to_update = player_snippet+"\n1 camp to action"
				_:
					text_to_update = player_snippet+"\n"+str(num)+" camps to action"
		"dig":
			text_to_update = player_snippet+"\nPick dig site"
		"choose_sab":
			text_to_update = player_snippet+"\nChoose site to bomb"
		"gameend":
			text_to_update = "PLAYER "+str(player)+" WINS!\nSpace to restart"
		"restart":
			text_to_update = player_snippet+"\nSpace again restarts"
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
