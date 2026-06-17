## DEPRECATED replaced by creature.gd and appropriate UI components in autobattler.tscn
class_name PartyMember extends TextureRect

@export var BASE_SPEED: int
@export var BASE_HEALTH: int
@export var BASE_STRENGTH: int
@export var member_name: String

var stats: Stats
@onready var hp_bar = $HPBar
var target_player: PartyMember
var dead: bool = false
var dna_strand: DNAStrand = DNAStrand.new()
var MAX_HEALTH: int
var health


func _ready() -> void:
	MAX_HEALTH = dna_strand.get_attribute_sum(DNABase.Attribute.HEALTH) + BASE_HEALTH
	print("max health")
	print(MAX_HEALTH)
	# Not sure if the stats are supposed to show the combined base and modified stats or just modified
	stats = Stats.new(
		dna_strand.get_attribute_sum(DNABase.Attribute.DAMAGE) + BASE_STRENGTH,
		MAX_HEALTH,
		dna_strand.get_attribute_sum(DNABase.Attribute.SPEED) + BASE_SPEED
	)
	health = MAX_HEALTH
	hp_bar.max_value = MAX_HEALTH
	hp_bar.value = health
	dna_strand.bases = [
		DNABase.new(randi() % DNABase.Shape.size(), DNABase.Attribute.HEALTH, stats.HP)
		,DNABase.new(randi() % DNABase.Shape.size(), DNABase.Attribute.DAMAGE, stats.STRENGTH)
		,DNABase.new(randi() % DNABase.Shape.size(), DNABase.Attribute.SPEED, stats.SPEED)
	]
	print("dna strands")
	print(dna_strand.bases)



func do_turn(combat_log: RichTextLabel) -> void:
	print("doing turn")
	var combat_text = "{0} Does {1} [color=orange][b]DAMAGE[/b][/color]".format(
		[member_name, stats.STRENGTH]
	)

	combat_log.append_text(combat_text)
	combat_log.newline()
	target_player.take_dmg(stats.STRENGTH, combat_log)


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
