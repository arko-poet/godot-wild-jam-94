class_name TitleBar extends Control

@export var title: String:
	set(value):
		title = value
		if _title_label:
			_title_label.text = value

@onready var _title_label: Label = %TitleLabel
@onready var menu_button: Button = %MenuButton
signal main_menu



func _ready() -> void:
	# just a hack cause exported variable is set before _title_label exists
	title = title
	menu_button.pressed.connect(_on_menu_button_pressed)

func _on_menu_button_pressed():
	main_menu.emit()
