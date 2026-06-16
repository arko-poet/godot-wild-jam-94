class_name PartyMember extends TextureRect

@export var BASE_SPEED: int
@export var BASE_HEALTH: int
@export var BASE_STRENGTH: int
@export var member_name: String
var stats: Stats
@onready var health = BASE_HEALTH
@onready var hp_bar = $HPBar
var target_player: PartyMember
var dead: bool = false
var base_stats = Stats.new(BASE_STRENGTH, BASE_HEALTH, BASE_SPEED)
var battle_name: String

func _init(input_battle_name: String = "placeholder", input_stats: Stats = base_stats) -> void:
	battle_name = input_battle_name
	stats = input_stats

func _ready() -> void:
	hp_bar.max_value = BASE_HEALTH
	hp_bar.value = health
	pass

func do_turn(combat_log: RichTextLabel) -> void:
	print("doing turn")
	var combat_text = "{0} Does {1} [color=orange][b]DAMAGE[/b][/color]".format([member_name, stats.STRENGTH])

	combat_log.append_text(combat_text)
	combat_log.newline()
	target_player.take_dmg(stats.STRENGTH, combat_log)
	pass

func take_dmg(dmg: int, combat_log: RichTextLabel) -> void:
	health -= dmg
	print("took damage")
	hp_bar.value = health
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
