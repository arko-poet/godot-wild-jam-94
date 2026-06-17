class_name GameController extends Node

const MUTATION_MUSIC := preload("res://assets/music/DnaScreen_BPM110_L58B_LOOP.mp3")
const AUTOBATTLE_MUSIC := preload("res://assets/music/DnaScreenPhase2_WO_Xylophone.mp3")

const AutobattlerScene := preload("res://game/autobattler/autobattler.tscn")

var archibald: PartyMember
var autobattler: Autobattler

@onready var mutation_screen: MutationScreen = %MutationScreen
@onready var win_stringer_player: AudioStreamPlayer = $WinStringerPlayer
@onready var lose_stringer: AudioStreamPlayer = $LoseStringer


func _ready() -> void:
	archibald = PartyMember.new()
	
	_initiate_autobattler()


func _initiate_mutation():
	ProjectMusicController.play_stream(MUTATION_MUSIC)

	autobattler.queue_free()
	
	mutation_screen.load_dna_strands(
		archibald.dna_strand, Strands.get_demo_strand()
	)

	mutation_screen.switch_scene(true)


func _initiate_autobattler():
	ProjectMusicController.play_stream(AUTOBATTLE_MUSIC)
	
	mutation_screen.switch_scene(false)

	autobattler = AutobattlerScene.instantiate()
	autobattler.autobattle_finished.connect(_on_battle_finished)
	add_child(autobattler)
	#autobattler.set_creatures(archibald)
	
	autobattler.auto_battle()


func _on_mutation_screen_mutation_finished() -> void:
	_initiate_autobattler()


func _on_battle_finished() -> void:
	ProjectMusicController.music_stream_player.stream_paused = true
	win_stringer_player.play()
	await win_stringer_player.finished
	_initiate_mutation()
