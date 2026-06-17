class_name GameController extends Node

const AutobattlerScene := preload("res://game/autobattler/autobattler.tscn")

var archibald: PartyMember
var autobattler: Autobattler

@onready var mutation_screen: MutationScreen = %MutationScreen


func _ready() -> void:
	archibald = PartyMember.new()
	
	_initiate_autobattler()


func _initiate_mutation():
	autobattler.queue_free()
	
	mutation_screen.load_dna_strands(
		archibald.dna_strand, Strands.get_demo_strand()
	)

	mutation_screen.switch_scene(true)


func _initiate_autobattler():
	mutation_screen.switch_scene(false)

	autobattler = AutobattlerScene.instantiate()
	autobattler.autobattle_finished.connect(_on_battle_finished)
	add_child(autobattler)
	#autobattler.set_creatures(archibald)
	
	autobattler.auto_battle()


func _on_mutation_screen_mutation_finished() -> void:
	_initiate_autobattler()


func _on_battle_finished() -> void:
	await get_tree().create_timer(2.0).timeout # TODO band aid to be remove
	_initiate_mutation()
