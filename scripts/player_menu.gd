extends PanelContainer

var menu_buttons : Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_focus()
	
func setup(acts_menu : Array[String]) -> void:
	for act in acts_menu:
		self._add_button(act)
	self._add_menu(menu_buttons)
	
#func add_action(text: String, action: Callable) -> void:
	#var button := add_button(Button.new(), text) as Button

func _add_button(text: String) -> Button:
	var button := Button.new() as Button
	button.text = text
	button.pressed.connect(_button_pressed.bind(button))
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.custom_minimum_size = Vector2i(64, 16)
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_buttons.append(button)
	return button

func _add_menu(buttons : Array[Button]) -> void:
	match menu_buttons.size():
		2:
			self.size = Vector2i(64, 32)
			set_theme_type_variation("Panel2")
		3:
			self.size = Vector2i(64, 48)
		4:
			self.size = Vector2i(64, 64)
			set_theme_type_variation("Panel4")
	for butt in buttons:
		%VBoxContainer.add_child(butt)
	
func _set_focus() -> void:
	if not menu_buttons.is_empty():
		var first: Button = menu_buttons.front()
		if first:
			first.grab_focus()

signal broadcast_menu_action

func _input(_event) -> void:
	if Input.is_action_pressed("action_b"):
		broadcast_menu_action.emit("exit_menu")

func _button_pressed(act_button : Button):
	match act_button.text:
		"Pass":
			#disable camp
			broadcast_menu_action.emit("pass_camp")
		"Back":
			broadcast_menu_action.emit("exit_menu")
		"Bomb":
			broadcast_menu_action.emit("choose_sabotage")
		"Dig":
			broadcast_menu_action.emit("choose_dig")
