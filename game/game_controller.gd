class_name GameController extends Node

const MUTATION_MUSIC := preload("res://assets/music/DnaScreen_BPM110_L58B_LOOP.mp3")
const AUTOBATTLE_MUSIC := preload("res://assets/music/DnaScreenPhase2_WO_Xylophone.mp3")

const AutobattlerScene := preload("res://game/autobattler/autobattler.tscn")

var archibald: Creature

var level := 1

@onready var autobattler: Autobattler = $Autobattler
@onready var mutation_screen: MutationScreen = %MutationScreen

@onready var win_stringer_player: AudioStreamPlayer = $WinStringerPlayer
@onready var lose_stringer_player: AudioStreamPlayer = $LoseStringerPlayer


func _ready() -> void:
	archibald = Creature.new("Archibald", DNAStrand.new(), Creature.Species.TURTLE)
	mutation_screen.stats.creature = archibald
	
	print(autobattler.ui)
	_initiate_autobattler()


func _initiate_mutation():
	ProjectMusicController.play_stream(MUTATION_MUSIC)

	autobattler.switch_scene(false)
	mutation_screen.switch_scene(true)
	
	mutation_screen.load_dna_strands(
		archibald.dna_strand, Strands.get_demo_strand(level)
	)

	mutation_screen.switch_scene(true)


func _initiate_autobattler():
	ProjectMusicController.play_stream(AUTOBATTLE_MUSIC)
	
	mutation_screen.switch_scene(false)
	autobattler.switch_scene(true)
	
	autobattler.title_bar.title = "BATTLE #%s" % level

	# TODO replace placeholder with enemy progression
	var placeholder_enemy := Creature.new("Salamander", DNAStrand.new(), Creature.Species.SALAMANDER, 45 + level * 5 , 5 + level, 3 + level)
	autobattler.set_creatures(archibald, placeholder_enemy)
	autobattler.auto_battle()


func _on_mutation_screen_mutation_finished() -> void:
	_initiate_autobattler()


func _on_autobattler_player_lost() -> void:
	ProjectMusicController.music_stream_player.stream_paused = true
	lose_stringer_player.play()
	await lose_stringer_player.finished
	get_tree().reload_current_scene()


func _on_autobattler_player_won() -> void:
	ProjectMusicController.music_stream_player.stream_paused = true
	win_stringer_player.play()
	await win_stringer_player.finished
	_initiate_mutation()
	level += 1
