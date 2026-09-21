extends Control

@onready var player1_score : Label = $PlayerDisplay/ScoreDisplay
@onready var player2_score : Label = $PlayerDisplay2/ScoreDisplay
@onready var player1_label : Label = $PlayerDisplay/PlayerNumber
@onready var player2_label : Label = $PlayerDisplay2/PlayerNumber
@onready var info_disp : Label = $InfoDisplay
@onready var square_info_disp : Label = $SquareInfoDisplay
@onready var triangle_info_disp : Label = $TriInfoDisplay
@onready var triangle_portrait : AnimatedSprite2D = $Triangle
@onready var square_portrait : AnimatedSprite2D = $Square

var primary_info_display : Label = info_disp

const portrait_emotion : Dictionary = {
	"default" : 0,
	"down" : 1,
	"losing" : 2,
	"winning" : 3
}

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
	var emotion : String = "default"
	var _player = player
	match type:
		"bones":
			text_to_update = player_snippet+"\nDug up " + str(num) + " bones"
		"sabotage":
			match num:
				0:
					emotion = "winning"
					text_to_update = "Sneaky devil.\n"+str(num)+" REP lost"
				4:
					emotion = "losing"
					text_to_update = "You're exposed!\n"+str(num)+" REP lost"
				_:
					_player = 99
					emotion = "down"
					var random_text: String = sab_snippet.pick_random()
					text_to_update = random_text+"\n"+str(num)+" REP lost"
		"start":
			var random_text: String = intro_snippet.pick_random()
			text_to_update = random_text
			_player = 99
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
			_player = 99
			match num:
				1:
					text_to_update = player_snippet+"\n1 camp to action"
				_:
					text_to_update = player_snippet+"\n"+str(num)+" camps to action"
		"dig":
			text_to_update = "Pick dig site"
		"choose_sab":
			emotion = "winning"
			text_to_update = "Choose site\nto sabotage"
		"gameend":
			emotion = "winning"
			text_to_update = "PLAYER "+str(player)+" WINS!\nSpace restarts"
		"restart":
			_player = 99
			text_to_update = player_snippet+"\nSpace again restarts"
	display_text(text_to_update, _player, emotion)

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

func display_text(text_to_update : String, player_disp : int, emotion : String = "default"):
	match player_disp:
		2:
			triangle_info_disp.text = text_to_update
			triangle_portrait.visible = true
			triangle_portrait.frame = portrait_emotion.get(emotion)
			square_portrait.visible = false
			info_disp.visible = false
			square_info_disp.visible = false
			triangle_info_disp.visible = true
		1:
			square_info_disp.text = text_to_update
			triangle_portrait.visible = false
			square_portrait.visible = true
			square_portrait.frame = portrait_emotion.get(emotion)
			info_disp.visible = false
			triangle_info_disp.visible = false
			square_info_disp.visible = true
		99:
			info_disp.text = text_to_update
			square_portrait.visible = false
			triangle_portrait.visible = false
			info_disp.visible = true
			triangle_info_disp.visible = false
			square_info_disp.visible = false
