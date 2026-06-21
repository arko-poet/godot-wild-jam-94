class_name GameController extends Node

const MUTATION_MUSIC := preload("res://assets/music/DnaScreen_BPM110_L58B_LOOP.mp3")
const AUTOBATTLE_MUSIC := preload("res://assets/music/DnaScreenPhase2(NoIntro).mp3")
const BOSS_MUSIC := preload("res://assets/music/Bossfight(NoIntro)_BPM120_L50B.mp3")
const SECRET_MUSIC := preload("res://assets/music/DnaScreenPhase4_BPM110_L58B_LOOP.mp3")
const MAIN_MENU_MUSIC := preload("res://assets/music/MainMenu_BPM70_L35B_LOOP.mp3")


const AutobattlerScene := preload("res://game/autobattler/autobattler.tscn")

var archibald: Creature
var enemy: Creature

var level := 1

@onready var autobattler: Autobattler = $Autobattler
@onready var mutation_screen: MutationScreen = %MutationScreen
@onready var turtle_name_scene: Control = $TurtleNameScene

@onready var win_stringer_player: AudioStreamPlayer = $WinStringerPlayer
@onready var lose_stringer_player: AudioStreamPlayer = $LoseStringerPlayer
@onready var pause_menu_controller = %PauseMenuController
@onready var end_credits: Control = %EndCredits


func _ready() -> void:
	archibald = Creature.new("Archibald", DNAStrand.new(), Creature.Species.TURTLE0)
	ProjectMusicController.play_stream(MUTATION_MUSIC)
	mutation_screen.stats.creature = archibald
	autobattler.title_bar.main_menu.connect(pause_menu_controller.pause)
	mutation_screen.title_bar.main_menu.connect(pause_menu_controller.pause)
	turtle_name_scene.title_bar.main_menu.connect(pause_menu_controller.pause)
	end_credits.continue_game.connect(_initiate_mutation)
	
	autobattler.switch_scene(false)
	mutation_screen.switch_scene(false)
	end_credits.hide()
	
	print(autobattler.ui)
	print(get_tree().paused)


func _initiate_mutation():
	end_credits.hide()
	autobattler.win_screen.visible = false
	ProjectMusicController.play_stream(MUTATION_MUSIC)

	autobattler.switch_scene(false)
	mutation_screen.switch_scene(true)
	
	mutation_screen.set_creatures(archibald, enemy, level)

	mutation_screen.switch_scene(true)


func _initiate_autobattler():

	if level == 20:
		ProjectMusicController.play_stream(SECRET_MUSIC)
	elif level == 7 or (level > 7 and level % 10 == 0):
		ProjectMusicController.play_stream(BOSS_MUSIC)
	else:
		ProjectMusicController.play_stream(AUTOBATTLE_MUSIC)
	mutation_screen.switch_scene(false)
	autobattler.switch_scene(true)
	
	autobattler.title_bar.title = "BATTLE #%s" % level

	# TODO replace placeholder with enemy progression
	enemy = Creatures.get_enemy(level)
	autobattler.set_creatures(archibald, enemy)
	autobattler.ally.health = autobattler.ally.max_health	
	autobattler.auto_battle()


func _on_mutation_screen_mutation_finished() -> void:
	_initiate_autobattler()


func _on_autobattler_player_lost() -> void:
	#autobattler.win_screen.visible = false
	ProjectMusicController.music_stream_player.stream_paused = true
	lose_stringer_player.play()
	await lose_stringer_player.finished
	SceneLoader.load_scene("res://template/scenes/menus/main_menu/main_menu_with_animations.tscn")


func _on_autobattler_player_won() -> void:
	ProjectMusicController.music_stream_player.stream_paused = true
	win_stringer_player.play()
	await win_stringer_player.finished
	if level == 7:
		level += 1
		autobattler.switch_scene(false)
		autobattler.win_screen.visible = false
		ProjectMusicController.play_stream(MAIN_MENU_MUSIC)
		end_credits.show()
	else:
		_initiate_mutation()
		level += 1


func _on_turtle_name_scene_name_chosen(turtle_name: String) -> void:
	archibald = Creature.new(turtle_name, DNAStrand.new(), Creature.Species.TURTLE0)
	#archibald.damage = 100
	turtle_name_scene.hide()
	_initiate_autobattler()
