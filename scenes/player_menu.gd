extends PanelContainer

var menu_buttons : Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_action("Dig", test)
	self.add_action("Sabotage", test)
	self.add_action("Quit!", test)
	self.add_action("Foruth", test)
	self.add_menu(menu_buttons)
	set_focus()	
	
func test() -> void:
	pass
	
func add_action(text: String, action: Callable) -> void:
	var button := add_button(Button.new(), text) as Button

func add_button(button: Button, text: String) -> Button:
	button.text = text
	button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.custom_minimum_size = Vector2i(64, 16)
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_buttons.append(button)
	return button

func add_menu(buttons : Array[Button]) -> void:
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
	
func set_focus() -> void:
	if not menu_buttons.is_empty():
		var button: Button = menu_buttons.front()
		if button:
			button.grab_focus()
