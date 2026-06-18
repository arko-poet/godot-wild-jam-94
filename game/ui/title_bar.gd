extends Control

@export var title: String:
	set(value):
		title = value
		if title_label:
			title_label.text = value


@onready var title_label: Label = %TitleLabel


func _ready() -> void:
	title = title
