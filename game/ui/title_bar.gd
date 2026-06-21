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

@onready var _1_speed_button: Button = %"1SpeedButton"
@onready var _2_speed_button: Button = %"2SpeedButton"
@onready var _4_speed_button: Button = %"4SpeedButton"

signal main_menu



func _ready() -> void:
	# just a hack cause exported variable is set before _title_label exists
	title = title
	menu_button.pressed.connect(_on_menu_button_pressed)
	
	if not speed_buttons:
		time_controls.hide()

func _on_menu_button_pressed():
	main_menu.emit()


func _on_speed_button1_pressed() -> void:
	Engine.time_scale = 1.0
	_1_speed_button.disabled = true
	_2_speed_button.disabled = false
	_4_speed_button.disabled = false
	
func _on_speed_button2_pressed() -> void:
	Engine.time_scale = 2.0
	_1_speed_button.disabled = false
	_2_speed_button.disabled = true
	_4_speed_button.disabled = false


func _on_speed_button4_pressed() -> void:
	Engine.time_scale = 4.0
	_1_speed_button.disabled = false
	_2_speed_button.disabled = false
	_4_speed_button.disabled = true
