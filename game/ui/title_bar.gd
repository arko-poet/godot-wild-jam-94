class_name TitleBar extends Control

@export var title: String:
	set(value):
		title = value
		if _title_label:
			_title_label.text = value
@export var speed_buttons := false

@onready var _title_label: Label = %TitleLabel
@onready var menu_button: Button = %MenuButton
@onready var time_controls: HBoxContainer = $TimeControls


signal main_menu



func _ready() -> void:
	# just a hack cause exported variable is set before _title_label exists
	title = title
	menu_button.pressed.connect(_on_menu_button_pressed)
	
	if not speed_buttons:
		time_controls.hide()

func _on_menu_button_pressed():
	main_menu.emit()
