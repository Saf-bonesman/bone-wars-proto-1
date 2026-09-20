extends PanelContainer

var menu_buttons : Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_focus()
	
func setup(acts_menu : Array[String]) -> void:
	for act in acts_menu:
		self.add_button(act)
	self.add_menu(menu_buttons)
	
#func add_action(text: String, action: Callable) -> void:
	#var button := add_button(Button.new(), text) as Button

func add_button(text: String) -> Button:
	var button := Button.new() as Button
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
		var first: Button = menu_buttons.front()
		if first:
			first.grab_focus()
