class_name PartyMember extends TextureRect

@export var MAX_SPEED: int
@export var MAX_HEALTH: int
@export var MAX_STRENGTH: int
@export var member_name: String

@onready var speed = MAX_SPEED
@onready var health = MAX_HEALTH
@onready var strength = MAX_STRENGTH
var target_player: PartyMember
var dead: bool = false

func _ready() -> void:
	pass

func do_turn() -> void:
	print("doing turn")
	print(target_player)
	target_player.take_dmg(strength)
	print("speed")
	print(speed)
	pass

func take_dmg(dmg: int) -> void:
	health -= dmg
	print("took damage")
	print(health)
	if health <= 0:
		handle_death()
	pass

func handle_death() -> void:
	dead = true
	print("died")
	self.visible = false
	pass
