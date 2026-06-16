class_name Stats extends Object

var STRENGTH: int
var HP: int
var SPEED: int


func _init(strength: int, hp: int, speed: int) -> void:
	STRENGTH = strength
	HP = hp
	SPEED = speed

func modify_stats(strength: int = 0, hp: int = 0, speed: int = 0):
	STRENGTH += strength
	HP += hp
	SPEED += speed
