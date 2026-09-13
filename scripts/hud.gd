extends Control

@onready var player1_score : Label = $PlayerDisplay/ScoreDisplay
@onready var player2_score : Label = $PlayerDisplay2/ScoreDisplay
@onready var player1_label : Label = $PlayerDisplay/PlayerNumber
@onready var player2_label : Label = $PlayerDisplay2/PlayerNumber
@onready var info_disp : Label = $InfoDisplay

func init_player_displays() -> void:
	player1_label.text = "P1"
	player2_label.text = "P2"
	player1_score.text = "00"
	player2_score.text = "00"

func update_info_display(type : String, num : int, player : int) -> void:
	var text_to_update : String = ""
	match type:
		"bones":
			text_to_update = "P" + str(player) + " got " + str(num) + " bones!"
		"sabotage":
			if (num == 0):
				text_to_update = "sneaky!!"
			elif num == 4:
				text_to_update = "exposed!!"
			else:
				text_to_update = "sabotage!"
		"turn":
			text_to_update = "P"+str(player)+"'s turn"
		"encamp":
			text_to_update = "new camp"
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
