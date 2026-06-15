class_name PartyMember extends TextureRect

@export var MAX_SPEED: int
@export var MAX_HEALTH: int
@export var MAX_STRENGTH: int
@export var member_name: String

@onready var speed: int = MAX_SPEED
@onready var health: int = MAX_HEALTH
@onready var strength: int = MAX_STRENGTH
var target_player: PartyMember
var dead: bool = false

func _ready() -> void:
	pass

func do_turn(combat_log: RichTextLabel, target_stats: Stats) -> void:
	print("doing turn")
	var combat_text = "{0} Does {1} [color=orange][b]DAMAGE[/b][/color]".format([member_name, strength])

	combat_log.append_text(combat_text)
	combat_log.newline()
	target_player.take_dmg(strength, combat_log, target_stats)
	pass

func take_dmg(dmg: int, combat_log: RichTextLabel, target_stats: Stats) -> void:
	health -= dmg
	print("took damage")
	target_stats.update_HP(health)
	if health <= 0:
		handle_death(combat_log)
	pass

func handle_death(combat_log: RichTextLabel) -> void:
	dead = true
	combat_log.append_text("{0} [color=red][b]DIES[/b][/color]".format([member_name]))
	combat_log.newline()
	print("died")
	#self.visible = false
	pass
