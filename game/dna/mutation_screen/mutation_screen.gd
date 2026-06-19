class_name MutationScreen extends Node

signal mutation_finished

const DNA_LABEL_TEXT := "%s's"

@onready var world: Node2D = $World
@onready var ui: Control = $UILayer/UI

@onready var player_creature: Sprite2D = $World/PlayerCreature
@onready var corpse: Sprite2D = $World/Corpse

@onready var left_strand_drawing: DnaStrandDrawing = $World/LeftStrandDrawing
@onready var right_strand_drawing: DnaStrandDrawing = $World/RightStrandDrawing

@onready var mutation_h_box: HBoxContainer = $UILayer/UI/MutationHBox
@onready var confirm_mutation_button: Button = $UILayer/UI/MutationHBox/ConfirmMutationButton
@onready var skip_mutation_button: Button = $UILayer/UI/MutationHBox/SkipMutationButton

@onready var shift_strand_up_button: TextureButton = $UILayer/UI/ShiftStrandUpButton
@onready var shift_strand_down_button: TextureButton = $UILayer/UI/ShiftStrandDownButton

@onready var next_battle_button: Button = $UILayer/UI/NextBattleButton

@onready var stats: StatsContainer = $UILayer/UI/Stats

@onready var creature_dna_label: Label = $UILayer/UI/CreatureDNALabel
@onready var corpse_dna_label: Label = $UILayer/UI/CorpseDNALabel


var ally: Creature
var enemy: Creature
var left_strand: DNAStrand
var right_strand: DNAStrand


func set_creatures(p_ally: Creature, p_enemy: Creature, level: int) -> void:
	ally = p_ally
	enemy = p_enemy
	
	player_creature.texture = Creatures.get_creature_texture(ally)
	corpse.texture = Creatures.get_creature_texture(enemy)
	
	creature_dna_label.text = DNA_LABEL_TEXT % ally.name
	corpse_dna_label.text = DNA_LABEL_TEXT % enemy.name
	
	if not ally.species_changed.is_connected(_on_species_changed):
		ally.species_changed.connect(_on_species_changed)
	
	left_strand = p_ally.dna_strand
	right_strand = Strands.get_demo_strand(level)
	
	left_strand_drawing.strand = left_strand
	right_strand_drawing.strand = right_strand
	right_strand_drawing.shift = 0
	
	next_battle_button.hide()
	mutation_h_box.show()


## shows/hides scene
func switch_scene(on := true) -> void:
	if on:
		world.show()
		ui.show()
	else:
		world.hide()
		ui.hide()


func _on_confirm_mutation_button_pressed() -> void:
	left_strand.combine_strands(right_strand, right_strand_drawing.shift, true)
	mutation_h_box.hide()
	next_battle_button.show()


func _on_skip_mutation_button_pressed() -> void:
	mutation_h_box.hide()
	next_battle_button.show()


func _on_shift_strand_up_button_pressed() -> void:
	right_strand_drawing.shift -= 1


func _on_shift_strand_down_button_pressed() -> void:
	right_strand_drawing.shift = min(right_strand_drawing.shift + 1, left_strand.bases.size())


func _on_next_battle_button_pressed() -> void:
	mutation_finished.emit()
	print("MUTATION FINISHED, NEXT BATTLE REQUESTED")


func _on_species_changed() -> void:
	player_creature.texture = Creatures.get_creature_texture(ally)
