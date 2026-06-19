extends Control

signal name_chosen(turtle_name: String)

const DEFAULT_NAME := "Archibald"

@onready var turtle_noises: AudioStreamPlayer = $TurtleNoises

@onready var line_edit: LineEdit = %LineEdit


func _on_button_pressed() -> void:
	var turtle_name = DEFAULT_NAME if line_edit.text.is_empty() else line_edit.text
	name_chosen.emit(turtle_name)


func _on_turtle_pressed() -> void:
	turtle_noises.play()
